workflow "Build and Push" {
  on = "push"
  resolves = [
    "Push Docker image"
  ]
}

action "Build Docker image" {
  uses = "docker://docker:stable"
  args = ["hack/build.sh"]
}

action "Master" {
  needs = "Build Docker image"
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Docker Login" {
  needs = "Master"
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Push Docker image" {
  needs = "Docker Login"
  uses = "docker://docker:stable"
  args = ["hack/publish.sh"]
}
