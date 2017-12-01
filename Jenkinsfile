/* first pass jenkins pipeline script for stand-alone dcm */
node
{
	def app
	stage('repo checkout')
	{
		checkout scm
	}

	stage('build all-in-one image')
	{
		sh 'cp ansible/roles/dcm/vars/secrets.yml.template ansible/roles/dcm/vars/secrets.yml' /* assume template values are sufficient for stand-alone testing */
		app = docker.build('dcm','-f docker/allinone.dockerfile .')
	}

	stage('test API endpoints')
	{
		app.withRun('-p 8886:80')
		{ c ->
			sh 'sleep 30' /* wait until healthy would be better */
			sh 'DCM_HOST=localhost:8886 ./ansible/roles/dcm/files/root/scripts/dcm-test01.sh dset_foo user_bar'
			sh 'sleep 5' /* wait for generator */
			sh 'DCM_HOST=localhost:8886 ./ansible/roles/dcm/files/root/scripts/dcm-test02.sh dset_foo'
		}
	}
}
