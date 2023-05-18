def branch = "cicd"
def repo = "git@github.com:nikymn/be-dumbmerch.git"
def cred = "appserver"
def dir = "~/be-dumbmerch"
def server = "nafis@103.37.125.112"
def imagename = "dumbmerch-be"
def dockerusername = "nikymn"

pipeline {
    agent any

    stages {
        stage('Repository pull') {
            steps {
                sshagent([cred]) {
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
		        mkdir ${dir}
                        cd ${dir}
			git init
                        git remote add origin ${repo}
			git pull origin master
			git branch ${branch}
			git checkout ${branch}
			git pull origin ${branch}
                        exit
                        EOF
                    """
                }
            }
        }

    stage('Image build') {
            steps {
                sshagent([cred]) {
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                        cd ${dir}
                        docker build -t ${dockerusername}/${imagename}:latest .
                        exit
                        EOF
                    """
                }
            }
        }

        stage('Running the image in a container') {
            steps {
                sshagent([cred]) {
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                        cd ${dir}
                        docker run -d -p 3000:3000 --name="${imagename}"  ${dockerusername}/${imagename}:latest
                        docker container stop ${dockerusername}/${imagename}
                        docker container rm ${dockerusername}/${imagename}
                        exit
                        EOF
                    """
                }
            }
        }

        stage('Image push') {
            steps {
               sshagent([cred]) {
			    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
				docker image push ${dockerusername}/${imagename}:latest
				docker rmi ${dockerusername}/${imagename}:latest
				exit
                    		EOF
			"""
		}
            }
        }
    }
}
