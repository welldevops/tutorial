def appGitUrl="https://github.com/simplytunde/tutorial"
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
