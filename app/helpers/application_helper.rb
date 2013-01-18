module ApplicationHelper 

	#Returns the full title on a per-page basis.

	def full_title(page_title)
		base_title = "Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

	def character_count(field_id, update_id, options = {})
		function = "$('#{update_id}').innerHTML = $F('#{field_id}').length;"
		out = javascript_tag(function) # set current length
		out += observe_field(field_id, options.merge(:function => function)) # and observe it
	end

end
