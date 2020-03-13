# docker fucntions
function drm() {
    docker rm $(docker ps -f "status=exited" -q -a)
}

function drmi() {
    docker rmi $(docker images -qf dangling=true)
}

function drmv() {
    docker volume rm $(docker volume ls -qf dangling=true)
}

#function terraform012() {
#    docker run --rm -it --env-file ~/.aws/.aws.env -w /code -v "${HOME}:/root/.terraform.d:ro" -v $(pwd):/code hashicorp/terraform:0.12.20 "${@}"
#}


function travis() {
    docker run --rm -it -w /code -v $(pwd):/code limed/travis:latest "${@}"
}

