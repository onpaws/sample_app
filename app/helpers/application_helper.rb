module ApplicationHelper
	#functions that deliver commonly needed content or functionality

	# Return a default title on a per-page basis
	def title
		base_title = "Paws Sample App"
		if @title.nil? 
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end

	def logo
		image_tag("lantern.png", :alt => "site logo") 
	end

end
