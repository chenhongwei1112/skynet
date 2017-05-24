	local Shape = require( "Shape" )
	local Circle = class("Circle", Shape)

	function Circle:ctor()
	    -- 如果继承类覆盖了 ctor() 构造函数，那么必须手动调用父类构造函数
	    -- 类名.super 可以访问指定类的父类
	    Circle.super.ctor(self, "circle")
	    self.radius = 100
	end

	function Circle:setRadius(radius)
	    self.radius = radius
	end

	-- 覆盖父类的同名方法
	function Circle:draw()
	    print("draw %s, raidus = %0.2f", self.shapeName, self.raidus)
	end

	return Circle
