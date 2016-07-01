applications = []
projects = {"SF"=>"DEV", "Default"=>"HCTEST", "bogus"=>"BOGUS DEV", "On line bank Release"=>"Banking-DEV"}

SCHEDULER.every '5s', :first_in => 0 do |job|
	totalDeployments = 0
	# Get all unique application names in projects array
	allApplications = []
	projects.each do |project,env|
		http = Net::HTTP.new("flow", "8000")
		req = Net::HTTP::Get.new(URI.escape("/rest/v1.0/projects/#{project}/applications"))
		req.basic_auth "admin", "changeme"
		response = http.request(req)
		applications = JSON.parse(response.body)["application"]
		if applications
			applications.each do |application|
				applicationName = application["applicationName"]
				unless allApplications.include? applicationName
					allApplications.push( {:project=>project, :application=>applicationName, :env=>env} )
				end 
			end
		end
	end

	allApplications.each do |app|
		projName = app[:project]
		appName = app[:application]
		env = app[:env]
		http = Net::HTTP.new("flow", "8000")
		req = Net::HTTP::Get.new(URI.escape("/rest/v1.0/projects/#{projName}/environments/#{env}/deploymentHistoryItems?applicationName=#{appName}&latest=false&processName=Deploy"))
		req.basic_auth "admin", "changeme"
		response = http.request(req)
		historyItem = JSON.parse(response.body)["deploymentHistoryItem"]
		if historyItem
			totalDeployments += historyItem.length
			completionTime = historyItem.last["completionTime"].to_i
			applications.push({:name => historyItem.last["applicationName"], :outcome => historyItem.last["status"], :completionTime => Time.at(completionTime/1000)})
		end
	end

	# applications = [
       # {:name => "appA", :outcome => "fail", :completionTime => "Wed - 06:45"},
       # {:name => "appB", :outcome => "pass", :completionTime => "Thurs - 01:15"},
       # {:name => "appC", :outcome => "fail", :completionTime => "Thurs - 13:27"}
	# ]
	
	appList = Hash.new({ value: "", value2: "" })

	applications.each do |app|
		if app[:name]
		appList[app] = { label: app[:name], value1: app[:outcome] }
		end
	end

	
	send_event('deploy48', { items: appList.values })
	send_event('deployments', { value: totalDeployments })
end
