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
job('create-infrastructure'){
     scm {
        git {
           remote {
               name('origin')
               url(appGitUrl)
           }
           branch(appGitUrlBranch)
        }
    }
    steps {
        shell("cd pipeline1/terraform && terraform init && terraform plan")
    }
}
