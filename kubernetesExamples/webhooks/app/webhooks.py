from flask import Flask, request, jsonify
import jsonpatch
import base64

warden = Flask(__name__)
#POST route for Admission Controller
@warden.route('/validate', methods=['POST'])
# Admission Control Logic - validating
def validating_webhook():
    request_info = request.get_json()
    uid = request_info["request"].get("uid")

    try:
        namespace = request_info["request"]["namespace"]
        if namespace != "myapp":
            return k8s_response(True, uid, "Pod is not in the 'myapp' namespace, skipping validation.")

        containers = request_info["request"]["object"]["spec"]["containers"]
        for container in containers:
            if container["image"] != "myapp:latest":
                return k8s_response(False, uid, "Validation failed: All containers must use the image 'myapp:latest'.")

        return k8s_response(True, uid, "Validation succeeded: All containers use the image 'myapp:latest'.")
    except Exception as e:
        return k8s_response(False, uid, "Validation failed: {}".format(str(e)))

# Function to respond back to the Admission Controller
def k8s_response(allowed, uid, message):
    return jsonify({
        "apiVersion": "admission.k8s.io/v1",
        "kind": "AdmissionReview",
        "response": {
            "allowed": allowed,
            "uid": uid,
            "status": {
                "message": message
            }
        }
    })

# POST route for Admission Controller
@warden.route("/mutate", methods=["POST"])
# Admission Control Logic - mutating
def mutatating_webhook():
    request_info = request.get_json()
    uid = request_info["request"].get("uid")

    try:
        namespace = request_info["request"]["namespace"]
        if namespace != "myapp":
            return k8s_response(True, uid, "Pod is not in the 'myapp' namespace, skipping mutation.")

        containers = request_info["request"]["object"]["spec"]["containers"]
        mutated = False
        for container in containers:
            image_parts = container["image"].split(":")
            # If the image is not 'myapp', fail
            if image_parts[0] != "myapp":
                return k8s_response(False, uid, "Mutation failed: All containers must use the image 'myapp'.")
            # If the image is not 'myapp:latest', change it to 'myapp:latest'
            if image_parts[0] == "myapp" and (len(image_parts) == 1 or image_parts[1] != "latest"):
                container["image"] = "myapp:latest"
                mutated = True

        if mutated: # If any container was mutated
            patch = jsonpatch.JsonPatch.from_diff(request_info["request"]["object"], request_info["request"]["object"])
            return jsonify({
                "apiVersion": "admission.k8s.io/v1",
                "kind": "AdmissionReview",
                "response": {
                    "uid": uid,
                    "allowed": True,
                    "patchType": "JSONPatch",
                    "patch": base64.b64encode(patch.to_string().encode()).decode()
                }
            })
        else: # If no container was mutated
            return k8s_response(True, uid, "No mutation needed: All containers already use the image 'myapp:latest'.")
    except Exception as e:
        return k8s_response(False, uid, "Mutation failed: {}".format(str(e)))

if __name__ == '__main__':
    warden.run(ssl_context=('certs/wardencrt.pem', 'certs/wardenkey.pem'), debug=True, host='0.0.0.0')