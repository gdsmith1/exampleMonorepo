# An HCL with some more advanced features

# Sets the default platforms to build for in a variable
variable "releaseplatforms" {
  default = ["linux/amd64", "linux/arm64"]
}

# Default group of targets
group "default" {
  targets = ["runner", "nexus"]
}

# Target for other targets to inherit from
target "_common" { # put shared attributes here to reduce redundancy
    platforms = releaseplatforms
    no-cache = true
    push = true
}

# A function to determine the repo based on whether the target is "nexus" or not
variable "expected" {
  default = "nexus"
}
function "isNexus" {
  params = [actual]
  result = "gdsmith1/${equal(actual, expected) ? "nexus" : "runner"}:latest" # A ternary operator to determine the repo value
}

# Defines the runner target
target "runner" {
  inherits = ["_common"]
  context = "./runner"
  dockerfile = "./Dockerfile"
  tags = [isNexus("runner")]
}

# Defines the nexus target
target "nexus" {
  inherits = ["_common"]
  context = "./nexus"
  dockerfile = "./Dockerfile"
  tags = [isNexus("nexus")]
  args = {
    NEXUS_DATA = "/sonatype-work/nexus3"
  }
}