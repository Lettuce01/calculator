static class RTYPE {
  public static final int VALUE = 0;
  public static final int EQUATE = 1;
  public static final int MINUS = 2;
  public static final int PLUS = 3;
  public static final int TIMES = 4;
  public static final int DIVIDE = 5;
  public static final int EXPONENT = 6;
  public static final int BRACKET = 7;
}

abstract class renderer {
  protected renderer mChild1;
  protected renderer mChild2;
  protected int mRType;
  
  abstract public renderer create(int rType, String value);
  abstract public renderer create(int rType, renderer arg);
  abstract public renderer create(int rType, renderer arg1, renderer arg2);
  
  abstract public void render();
}

class text_renderer extends renderer {
  private String mText;
  
  text_renderer() {
    mText = "";
  }
  text_renderer(String text) {
    mText = text;
  }

  @Override
  public renderer create(int rType, String value) {
    if (rType == RTYPE.VALUE) {
      text_renderer new_renderer = new text_renderer(value);
      new_renderer.mRType = rType;
      return new_renderer;
    } else {
      print(" ~ TYPE MISMATCH (VALUE) ~ ");
      return this;
    }
  }
  @Override
  public renderer create(int rType, renderer arg) {
    if (rType == RTYPE.BRACKET) {
      text_renderer new_renderer = new text_renderer();
      new_renderer.mRType = rType;
      new_renderer.mChild1 = arg;
      return new_renderer;
    } else {
      print(" ~ TYPE MISMATCH (BRACKET) ~ ");
      return this;
    }
  }
  @Override
  public renderer create(int rType, renderer arg1, renderer arg2) {
    if ((rType == RTYPE.EQUATE) ||
        (rType == RTYPE.MINUS) ||
        (rType == RTYPE.PLUS) ||
        (rType == RTYPE.TIMES) ||
        (rType == RTYPE.DIVIDE) ||
        (rType == RTYPE.EXPONENT)) {
      text_renderer new_renderer = new text_renderer();
      new_renderer.mRType = rType;
      new_renderer.mChild1 = arg1;
      new_renderer.mChild2 = arg2;
      switch (rType) {
        case RTYPE.EQUATE:
          new_renderer.mText = "=";
          break;
        case RTYPE.MINUS:
          new_renderer.mText = "-";
          break;
        case RTYPE.PLUS:
          new_renderer.mText = "+";
          break;
        case RTYPE.TIMES:
          new_renderer.mText = "*";
          break;
        case RTYPE.DIVIDE:
          new_renderer.mText = "/";
          break;
        case RTYPE.EXPONENT:
          new_renderer.mText = "^";
          break;
        default:
          new_renderer.mText = "?";
      }
      return new_renderer;
    } else {
      print(" ~ TYPE MISMATCH (DUAL) ~ ");
      return this;
    }
  }
  
  @Override
  public void render() {
    switch(mRType) {
      case RTYPE.VALUE:
        print(mText);
        break;
      case RTYPE.BRACKET:
        print("(");
        mChild1.render();
        print(")");
        break;
      case RTYPE.EQUATE:
      case RTYPE.MINUS:
      case RTYPE.PLUS:
      case RTYPE.TIMES:
      case RTYPE.DIVIDE:
      case RTYPE.EXPONENT:
        mChild1.render();
        print(mText);
        mChild2.render();
        break;
      default:
        print(" ~ Unknown Operator Type ~ ");
    }
    if (mRType == RTYPE.EQUATE) {
      print ("\n");
    }
  }
}

//-------------------------------------------------- graphic_renderer  
class graphic_renderer extends renderer {
  private String mText;
  protected float mXSize;
  protected float mYSize;
  
  graphic_renderer() {
    mText = "";
  }
  graphic_renderer(String text) {
    mText = text;
  }

  @Override
  public renderer create(int rType, String value) {
    if (rType == RTYPE.VALUE) {
      graphic_renderer new_renderer = new graphic_renderer(value);
      new_renderer.mRType = rType;
      new_renderer.mXSize = textWidth(value);
      new_renderer.mYSize = 10;                  // Arbitrary. We need a global (for the class) text size (height) that gets specified...
      return new_renderer;
    } else {
      print(" ~ TYPE MISMATCH (VALUE) ~ ");
      return this;
    }
  }
  @Override
  public renderer create(int rType, renderer arg) {
    if (rType == RTYPE.BRACKET) {
      graphic_renderer new_renderer = new graphic_renderer();
      graphic_renderer castArg = (graphic_renderer) arg;
      new_renderer.mRType = rType;
      new_renderer.mChild1 = castArg;
      new_renderer.mXSize = castArg.mXSize + textWidth("()");
      new_renderer.mYSize = castArg.mYSize;
      return new_renderer;
    } else {
      print(" ~ TYPE MISMATCH (BRACKET) ~ ");
      return this;
    }
  }
  @Override
  public renderer create(int rType, renderer arg1, renderer arg2) {
    if ((rType == RTYPE.EQUATE) ||
        (rType == RTYPE.MINUS) ||
        (rType == RTYPE.PLUS) ||
        (rType == RTYPE.TIMES) ||
        (rType == RTYPE.DIVIDE) ||
        (rType == RTYPE.EXPONENT)) {
      graphic_renderer new_renderer = new graphic_renderer();
      graphic_renderer castArg1 = (graphic_renderer) arg1;
      graphic_renderer castArg2 = (graphic_renderer) arg2;
      new_renderer.mRType = rType;
      new_renderer.mChild1 = castArg1;
      new_renderer.mChild2 = castArg2;
      switch (rType) {
        case RTYPE.EQUATE:
          new_renderer.mText = "=";
          break;
        case RTYPE.MINUS:
          new_renderer.mText = "-";
          break;
        case RTYPE.PLUS:
          new_renderer.mText = "+";
          break;
        case RTYPE.TIMES:
          new_renderer.mText = "*";
          break;
        case RTYPE.DIVIDE:
          new_renderer.mText = "/";
          break;
        case RTYPE.EXPONENT:
          new_renderer.mText = "^";
          break;
        default:
          new_renderer.mText = "?";
      }
      new_renderer.mXSize = castArg1.mXSize + textWidth(new_renderer.mText) + castArg2.mXSize;
      return new_renderer;
    } else {
      print(" ~ TYPE MISMATCH (DUAL) ~ ");
      return this;
    }
  }
  
  @Override
  public void render() {
    render(10, 10);
  }
  
  protected void render (float x, float y) {
    switch(mRType) {
      case RTYPE.VALUE:
        text(mText, x, y);
        break;
      case RTYPE.BRACKET:
        text("(", x, y);
        graphic_renderer castChild = (graphic_renderer) mChild1;
        castChild.render(x + textWidth("("), y);
        text(")", x + textWidth("(") + castChild.mXSize, y);
        break;
      case RTYPE.EQUATE:
      case RTYPE.MINUS:
      case RTYPE.PLUS:
      case RTYPE.TIMES:
      case RTYPE.DIVIDE:
      case RTYPE.EXPONENT:
        graphic_renderer castChild1 = (graphic_renderer) mChild1;
        graphic_renderer castChild2 = (graphic_renderer) mChild2;
        castChild1.render(x, y);
        text(mText, x + castChild1.mXSize, y);
        castChild2.render(x + castChild1.mXSize + textWidth(mText), y);
        break;
      default:
        print(" ~ Unknown Operator Type ~ ");
    }
  }
  
}

