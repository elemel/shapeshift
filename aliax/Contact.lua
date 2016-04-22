local Contact = {}
Contact.__index = Contact

function Contact.new(args)
	local contact = {}
	contact:init(args or {})
	return contact
end

function Contact:init(args)
	self.world = args.world
	self.body1, self.body2 = args.body1, args.body2
end

function Contact:destroy()
end

function Contact:update()
end

return Contact
