def appGitUrl="https://github.com/simplytunde/docker"
def appGitUrlBranch="master"
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
