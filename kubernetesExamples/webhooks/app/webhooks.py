from flask import Flask, request, jsonify
import re
import jsonpatch
import base64

warden = Flask(__name__)

#POST route for Admission Controller
@warden.route('/validate', methods=['POST'])
#Admission Control Logic - validating
def validating_webhook():
    request_info = request.get_json()
    uid = request_info["request"].get("uid")

    # Code for validating webhook HERE
    # Validation logic to ensure that all containers in the pod are using the image 'myapp:latest' if the pod is in the 'myapp' namespace
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

#Function to respond back to the Admission Controller
def k8s_response(allowed, uid, message):
     return jsonify({"apiVersion": "admission.k8s.io/v1", "kind": "AdmissionReview", "response": {"allowed": allowed, "uid": uid, "status": {"message": message}}})

#POST route for Admission Controller
#@warden.route("/mutate", methods=["POST"])
#Admission Control Logic - mutating
#def mutatating_webhook():
#    request_info = request.get_json()
#    uid = request_info["request"].get("uid")

    # Code for mutating webhook HERE
if __name__ == '__main__':
    warden.run(ssl_context=('certs/wardencrt.pem', 'certs/wardenkey.pem'),debug=True, host='0.0.0.0')
