def configGitUrl="https://github.com/simplytunde/tutorial"
def configGitUrlBranch="master"
job('deploy-to-qa'){
     scm {
        git {
           remote {
               name('origin')
               url(configGitUrl)
           }
           branch(configGitUrlBranch)
        }
    }
    steps {
        shell("cd ${WORKSPACE}/tutorial/pipeline1/ansible && ansible-playbook playbooks/install_locally.yml -i inventories/calendarapp.yml --extra-vars "release=feature"")
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
