local Contact = {}
Contact.__index = Contact

function Contact.new(args)
	local contact = setmetatable({}, Contact)
	contact:init(args or {})
	return contact
end

function Contact:init(args)
	self.world = args.world
	self.body1, self.body2 = args.body1, args.body2
	self.cellCount = 0

	self.world.contacts[self] = true

	self.body1.contacts[self.body2] = self
	self.body2.contacts[self.body1] = self
end

function Contact:destroy()
	self.body2.contacts[self.body1] = nil
	self.body1.contacts[self.body2] = nil

	self.world.contacts[self] = nil

	self.body1, self.body2 = nil, nil
	self.world = nil
end

function Contact:getDistance()
	return self.body1:getDistance(self.body2)
end

return Contact
