class library {
  private String mXMLFileName;
  private String mTitle;
  private ArrayList<formula> mFormulaList = new ArrayList<formula>();
  
  library() {
    // New library. Boring
  }
  library(String title){
    mTitle = title;
  }
  
  public boolean loadLibrary(String XMLFileName) {
    XML XMLLibrary = loadXML(XMLFileName);
    if (XMLLibrary == null) {
      // File not found
      return false;
    } else {
      // File exists
      if (XMLLibrary.hasAttribute("Title")) {
        mTitle = XMLLibrary.getString("Title");
      }
      XML[] XMLFormulae = XMLLibrary.getChildren("Formula");
      for (XML thisFormula : XMLFormulae) {
        formula newFormula = new formula(thisFormula);
        addFormula(newFormula);
      }
      mXMLFileName = XMLFileName;
      return true;
    }
  }
  public boolean saveLibrary() {
    if (mXMLFileName != "") {
      return saveLibrary(mXMLFileName);
    }
    return false;
  }
  public boolean saveLibrary(String XMLFileName) {
    mXMLFileName = XMLFileName;
    XML XMLFile = new XML("Library");
    if (mTitle != "") {
      XMLFile.setString("Title", mTitle);
    }
    for (formula thisFormula : mFormulaList) { 
      XMLFile.addChild(thisFormula.createXML());
    }
    saveXML(XMLFile, mXMLFileName);
    // Return true if save is successful (Should handle exceptions from saveXML()???)
    return true;
  }
  public void addFormula (formula formulaToAdd) {
    mFormulaList.add(formulaToAdd);
  }
  public formula getFormula (int index) {
    if (index >= mFormulaList.size()) {
      println ("Index does not exist in library");
    } else {
      return mFormulaList.get(index);
    }
    return null;
  }
  public void printLibrary() {
    println("Library " + mTitle);
    for (formula thisFormula : mFormulaList) {
      String title = thisFormula.getTitle();
      if (title != "") {
        println("  " + title);
        print("  ");
        String description = thisFormula.getDesc();
        if (description != "") {
          println("  " + description);
          print("    ");
        }
      }
      print("  ");
      thisFormula.stdPrint();
    }
  }  
}

