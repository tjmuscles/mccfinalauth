node {
    stage('Checkout ') {
        git url: 'https://github.com/tjmuscles/mccfinalauth.git'
    }
    
    stage('Gradle build') {
        sh 'gradle clean build'
    }
    
    stage ("Gradle Bootjar-Package - AuthService") {
        sh 'gradle bootjar'
    }
	
	stage ("Containerize the app-docker build - AuthApi") {
        sh 'docker build --rm -t mcc-auth:v1.0 .'
        sh 'minikube image load mcc-auth:v1.0'
    }
    
    stage ("Inspect the docker image - AuthApi"){
        sh "docker images mcc-auth:v1.0"
        sh "docker inspect mcc-auth:v1.0"
    }
    
    stage ("Run Docker container instance - AuthApi"){
        sh "docker run -d --rm --name mcc-auth -p 8081:8081 mcc-auth:v1.0"
     }
    
    stage('User Acceptance Test') {
    
    	def response= input message: 'Is this build good to go?',
    	parameters: [choice(choices: 'Yes\nNo',
    	description: '', name: 'Pass')]
    	
    	if(response=="Yes") {
		    stage('Deploy to K8S') {
			   	sh "docker stop mcc-auth"
	      		sh "kubectl create deployment mcc-auth --image=mcc-auth:v1.0"
  		        sh "kubectl set env deployment/mcc-auth API_HOST=\$(kubectl get service/mcc-data -o jsonpath='{.spec.clusterIP}'):8080"
	      		sh "kubectl expose deployment mcc-auth --type=LoadBalancer --port=8081"
			}
		}
	}
}
