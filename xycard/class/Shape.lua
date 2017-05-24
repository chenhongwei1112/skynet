	-- 定义名为 Shape 的基础类
	local Shape = class("Shape")

	-- ctor() 是类的构造函数，在调用 Shape.new() 创建 Shape 对象实例时会自动执行
	function Shape:ctor(shapeName)
	    self.shapeName = shapeName
	    printf("Shape:ctor(%s)", self.shapeName)
	end

	-- 为 Shape 定义个名为 draw() 的方法
	function Shape:draw()
	    printf("draw %s", self.shapeName)
	end

	return Shape