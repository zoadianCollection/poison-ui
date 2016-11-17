module poison.ui.space;

import poison.core : Point, Size, Edge, Location, EventObserver, ChangeEventArgs;

/// A wrapper around a space.
class Space : EventObserver {
  private:
  /// The position.
  Point _position;

  /// The size.
  Size _size;

  /// The margin.
  Edge _margin;

  /// The padding.
  Edge _padding;

  public:
  /**
  * Creates a new space.
  * Params:
  *   position =  The position.
  *   size =      The size.
  */
  this(Point position, Size size) {
    assert(position !is null);
    assert(size !is null);

    _position = position;
    _size = size;

    _margin = new Edge(0,0,0,0);
    _padding = new Edge(0,0,0,0);
  }

  @property {
    /// Gets the position of the space.
    Point position() { return _position; }

    /// Sets the position of the space.
    void position(Point newPosition) {
      auto oldPosition = _position;
      _position = newPosition;

      fireEvent("position", new ChangeEventArgs!Point(oldPosition, _position));
    }

    /// Gets the x coordinate of the space.
    ptrdiff_t x() { return _position.x; }

    /// Gets the y coordinate of the space.
    ptrdiff_t y() { return _position.y; }

    /// Gets the size of the space.
    Size size() { return _size; }

    /// Sets the size of the space.
    void size(Size newSize) {
      auto oldSize = _size;
      _size = newSize;

      fireEvent("size", new ChangeEventArgs!Size(oldSize, _size));
    }

    /// Gets the width of the space.
    size_t width() { return _size.width; }

    /// Gets the height of the space.
    size_t height() { return _size.height; }

    /// Gets the margin of the space.
    Edge margin() { return _margin; }

    /// Sets the margin of the space.
    void margin(Edge newMargin) {
      auto oldMargin = _margin;
      _margin = newMargin;

      fireEvent("margin", new ChangeEventArgs!Edge(oldMargin, _margin));
    }

    /// Gets the top margin of the space.
    ptrdiff_t topMargin() { return _margin.top; }

    /// Gets the right margin of the space.
    ptrdiff_t rightMargin() { return _margin.right; }

    /// Gets the bottom margin of the space.
    ptrdiff_t bottomMargin() { return _margin.bottom; }

    /// Gets the left margin of the space.
    ptrdiff_t leftMargin() { return _margin.left; }

    /// Gets the padding of the space.
    Edge padding() { return _padding; }

    /// Sets the padding of the space.
    void padding(Edge newPadding) {
      auto oldPadding = _padding;
      _padding = newPadding;

      fireEvent("padding", new ChangeEventArgs!Edge(oldPadding, _padding));
    }
  }

  /**
  * Moves the space to another space.
  * Params:
  *   target =  The target of the space.
  */
  void moveTo(Location location)(Space target) {
    assert(target !is null);

    auto newX = target.x;
    auto newY = target.y;

    static if (location == Location.northWest) {
      newX -= width + target.marginLeft;
      newY -= height + target.marginTop;
    }
    else static if (location == Location.north) {
      newY -= height + target.marginTop;
    }
    else static if (location == Location.northEast) {
      newX += target.width + target.marginRight;
      newY -= height + target.marginTop;
    }
    else static if (location == Location.east) {
      newX += target.width + target.marginRight;
    }
    else static if (location == Location.southEast) {
      newX += target.width + target.marginRight;
      newY += target.height + target.marginBottom;
    }
    else static if (location == Location.south) {
      newY += target.height + target.marginBottom;
    }
    else static if (location == Location.southWest) {
      newX -= width + target.marginLeft;
      newY += target.height + target.marginBottom;
    }
    else static if (location == Location.west) {
      newX -= width + target.marginLeft;
    }
    else {
      static assert(0);
    }

    position = new Point(newX, newY);
  }

  /**
  * Moves the space into another space.
  * Params:
  *   target =  The space to move the space into.
  */
  void moveIn(Location location)(Space target) {
    assert(target !is null);

    auto newX = target.x;
    auto newY = target.y;

    static if (location == Location.northWest) {
      newX += target.paddingLeft;
      newY += target.paddingTop;
    }
    else static if (location == Location.north) {
      newX += (target.width / 2) - (width / 2);
      newY += target.paddingTop;
    }
    else static if (location == Location.northEast) {
      newX += target.width - (target.paddingRight + width);
    }
    else static if (location == Location.east) {
      newX += target.width - (target.paddingRight + width);
      newY += (target.height / 2) - (height / 2);
    }
    else static if (location == Location.southEast) {
      newX += target.width - (target.paddingRight + width);
      newY += targer.height - (target.paddingBottom + height);
    }
    else static if (location == Location.south) {
      newX += (targer.width / 2) - (width / 2);
      newY += targer.height - (target.paddingBottom + height);
    }
    else static if (location == Location.southWest) {
      newX += target.paddingLeft;
      newY += target.height - (target.paddingBottom + height);
    }
    else static if (location == Location.west) {
      newX += target.paddingLeft;
      newY += (target.height / 2) - (height / 2);
    }
    else {
      static assert(0);
    }

    position = new Point(newX, newY);
  }

  /**
  * Centers the x coordinate of the space relative to another space.
  * Params:
  *   target =  The target to be relative to.
  */
  void centerX(Space target) {
    position = new Point((target.width / 2) - (width / 2), y);
  }

  /**
  * Centers the y coordinate of the space relative to another space.
  * Params:
  *   target =  The target to be relative to.
  */
  void centerY(Space target) {
      position = new Point(x, (target.height / 2) - (height / 2));
  }

  /**
  * Centers the space relative to another space.
  * Params:
  *   target =  The target to be relative to.
  */
  void center(Space target) {
    position = new Point((target.width / 2) - (width / 2), (target.height / 2) - (height / 2));
  }

  void moveX(ptrdiff_t amount) {
    position = new Point(x + amount, y);
  }

  void moveY(ptrdiff_t amount) {
    position = new Point(x, y + amount);
  }

  /**
  * Checks whether the space intersects with a point.
  * Params:
  *   p = The point to check for intersection with.
  */
  bool intersect(Point p) {
		return (p.x > this.x) &&
			(p.x < (this.x + this.width)) &&
			(p.y > this.y) &&
			(p.y < (this.y + this.height));
	}

  /**
  * Checks whether the space intersects with another space.
  * Params:
  *   target = The space to check for intersection with.
  */
  bool intersect(Space target) {
    return(target.x < this.x + this.width) &&
      (this.x < (target.x + target.width)) &&
      (target.y < this.y + this.height) &&
      (this.y < target.y + target.height);
   }
}
