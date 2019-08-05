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

function travis() {
    docker run --rm -it -w /code -v $(pwd):/code limed/travis:latest "${@}"
}

