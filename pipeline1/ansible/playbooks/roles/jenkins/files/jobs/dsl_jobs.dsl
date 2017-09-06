def appGitUrl="https://github.com/simplytunde/tutorial"
def appGitUrlBranch="master"
job('deploy-to-qa'){
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
