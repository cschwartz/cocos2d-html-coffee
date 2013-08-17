@CircleSprite = cc.Sprite.extend
    ctor: ->
      @_super()
      @_degree = 0

    draw: ->
      cc.drawingUtil.setDrawColor4B(255,255,255,255);

      if (@_degree < 0)
        @_degree = 360
      cc.drawingUtil.drawCircle(cc.PointZero(), 30, cc.DEGREES_TO_RADIANS(@_degree), 60, true)

    myUpdate: (dt) ->
      @_degree -= 6

@Helloworld = cc.Layer.extend
    init: ->
      selfPointer = this
      @_super()

      size = cc.Director.getInstance().getWinSize()

      closeItem = cc.MenuItemImage.create(
        "images/CloseNormal.png",
        "images/CloseSelected.png",
        ->
          history.go(-1)
        , @)

      closeItem.setAnchorPoint(cc.p(0.5, 0.5))

      menu = cc.Menu.create(closeItem)
      menu.setPosition(cc.PointZero())
      @addChild(menu, 1)
      closeItem.setPosition(cc.p(size.width - 20, 20))

      @helloLabel = cc.LabelTTF.create("Hello World", "Arial", 38)
      @helloLabel.setPosition(cc.p(size.width / 2, 0))
      @addChild(@helloLabel, 5)

      lazyLayer = cc.Layer.create()
      @addChild(lazyLayer)

      @sprite = cc.Sprite.create("images/HelloWorld.png")
      @sprite.setPosition(cc.p(size.width / 2, size.height / 2))
      @sprite.setScale(0.5)
      @sprite.setRotation(180)

      lazyLayer.addChild(@sprite, 0)

      rotateToA = cc.RotateTo.create(2, 0)
      scaleToA = cc.ScaleTo.create(2, 1, 1)

      @sprite.runAction(cc.Sequence.create(rotateToA, scaleToA))

      @circle = new CircleSprite()
      @circle.setPosition(cc.p(40, size.height - 60))
      @addChild(this.circle, 2)
      @circle.schedule(this.circle.myUpdate, 1 / 60);

      @helloLabel.runAction(cc.Spawn.create(cc.MoveBy.create(2.5, cc.p(0, size.height - 40)),cc.TintTo.create(2.5,255,125,0)))

      @setTouchEnabled(true)
      true

    menuCloseCallback: (sender) ->
      cc.Director.getInstance().end()

    onTouchesBegan: (touches, events) ->
      @isMouseDown = true

    onTouchesMoved: (touches, event) ->
      if (@isMouseDown)
        if (touches)
          @circle.setPosition(cc.p(touches[0].getLocation().x, touches[0].getLocation().y))
    
    onTouchesEnded: (touches, event) ->
      @isMouseDown = false;
    
    onTouchesCancelled: (touches, event) ->
      console.log("onTouchesCancelled")

@HelloWorldScene = cc.Scene.extend
  onEnter: ->
    @_super()
    layer = new Helloworld()
    layer.init()
    @addChild(layer)

