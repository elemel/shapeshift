local Cell = {}
Cell.__index = Cell

function Cell.new(args)
	local cell = setmetatable({}, Cell)
	cell:init(args or {})
	return cell
end

function Cell:init(args)
	self.x, self.y = args.x, args.y
	self.bodies = {}
end

return Cell
