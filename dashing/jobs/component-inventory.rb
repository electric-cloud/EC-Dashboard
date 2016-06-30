hrows = [
  { cols: [ {value: 'Component'}, {value: 'DEV'}, {value: 'QA'}, {value: 'PROD'} ] }
]


SCHEDULER.every '5s', :first_in => 0 do |job|
	rows = []

	http = Net::HTTP.new("localhost", "8000")
	req = Net::HTTP::Get.new("/rest/v1.0/projects/SF/environments/DEV/deploymentHistoryItems?applicationName=Store%20Front&latest=false&processName=Deploy")
	req.basic_auth "admin", "changeme"
	response = http.request(req)
	components = JSON.parse(response.body)["deploymentHistoryItem"][0]["deploymentDetailsItem"]

	
	components.each do |component|
		rows.push({ cols: [ {value: component["componentName"]}, {value: component["actualArtifactVersion"]}, {value: rand(5)}, {value: rand(5)} ]})
	end

	send_event('component-inventory', { hrows: hrows, rows: rows } )
end




