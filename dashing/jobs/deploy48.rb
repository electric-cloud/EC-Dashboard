applications = [
	{:name => "appA", :outcome => "pass", :completionTime => "Wed - 06:45"},
	{:name => "appB", :outcome => "pass", :completionTime => "Thurs - 01:15"},
	{:name => "appC", :outcome => "fail", :completionTime => "Thurs - 13:27"}
]

appList = Hash.new({ value: "", value2: "" })

SCHEDULER.every '5s', :first_in => 0 do |job|
	http = Net::HTTP.new("localhost", "8000")
	req = Net::HTTP::Get.new("/rest/v1.0/projects")
	req.basic_auth "admin", "changeme"
	response = http.request(req)
	#projectName = JSON.parse(response.body)["project"][0]["projectName"]

	applications.each do |app|
		appList[app] = { label: app[:name], value1: app[:outcome], value2: app[:completionTime] }
	end

	send_event('deploy48', { items: appList.values })
end
