def appGitUrl="https://github.com/simplytunde/docker"
def appGitUrlBranch="master"
job('hello-world') {
    steps {
        shell('echo "Hello World!"')
    }
}
job('deploy-to-instance'){
     scm {
        git {
           remote {
               name('origin')
               url(appGitUrl)
           }
           branch(appGitUrlBranch)
        }
    }
}
