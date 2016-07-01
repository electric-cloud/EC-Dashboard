hrows = [
  { cols: [ {value: 'Component'}, {value: 'DEV'}, {value: 'QA'}, {value: 'PROD'} ] }
]


SCHEDULER.every '5s', :first_in => 0 do |job|
	rowData = []
	envs= ["DEV", "QA", "PROD"]
	envs.each do |env|

		http = Net::HTTP.new("flow", "8000")
		req = Net::HTTP::Get.new("/rest/v1.0/projects/SF/environments/#{env}/deploymentHistoryItems?applicationName=Store%20Front&latest=false&processName=Deploy")
		req.basic_auth "admin", "changeme"
		response = http.request(req)
		components = JSON.parse(response.body)["deploymentHistoryItem"][0]["deploymentDetailsItem"]
		rowData.push({:env => env, :comps => components})	

	end

	# Get full component list
	allComponents = []
	rowData.each do |rowD|
		rowD[:comps].each do |comp|
			unless allComponents.include? comp["componentName"]
				allComponents.push( comp["componentName"])
			end 
		end
	end

	#puts allComponents
	#            env        comps
	#puts rowData[0][:comps][0]["actualArtifactVersion"]
	#puts rowData[0][:comps].find {|x| x['componentName'] == 'Vendor PL' }

	rows = []
	allComponents.each do |comp|
		# Get values for each environment
		#puts comp
		vals = []
		vals.push ({value: comp})
		rowData.each do |env|
			version = env[:comps].find {|x| x['componentName'] == comp }["actualArtifactVersion"]
			vals.push ({value: version})
		end
		rows.push({cols: vals})
		#puts vals
	end
	
	send_event('component-inventory', { hrows: hrows, rows: rows } )
end




