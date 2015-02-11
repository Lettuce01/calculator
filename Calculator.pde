void setup() {
  size(500, 100);
  
  library myLibrary = createTestLibrary();

  myLibrary.printLibrary();
  
/*  
  myLibrary.saveLibrary("TestXML.xml");
  
  library LoadLibrary = new library();
  println("Result = " + LoadLibrary.loadLibrary("TestXML.xml"));
  LoadLibrary.printLibrary();
*/  
}

library createStdLibrary() {
  library stdLibrary = new library("Std Library");
  // Create formulae
  // Add fomulae to library
  // Provide some feedback to the console
  // Return the new library
  return stdLibrary;
}

library createTestLibrary() {
  library testLibrary = new library("Test Library");
  
  // Create test formulae
  formula ohmsLaw = new formula(new argument("V", "V"), new multiply(new argument("I", "A"), new argument("R", "ohms")));
  node scalar = new argument("x", "units");
  //ohmsLaw.multiplyBy(scalar);
  ohmsLaw.stdPrint();
  ohmsLaw.render();
  
  formula test = new formula(new divide(new subtract(new argument("A", "a"), new argument("B", "b")), new argument("C", "c")), new addition(new argument("D", "d"), new argument("E", "e")));
  test.multiplyBy(scalar);
  test.stdPrint();
  test.render();
  
  formula test2 = new formula(new divide(new subtract(new argument("A", "a"), new argument("B", "b")), new argument("C", "c")), new bracket(new addition(new argument("D", "d"), new argument("E", "e"))));
  test2.multiplyBy(scalar);
  test2.stdPrint();
  test2.setRenderer(new graphic_renderer());
  test2.render();
  
  // Add formulae to library
  testLibrary.addFormula(ohmsLaw);
  testLibrary.addFormula(test);
  testLibrary.addFormula(test2);
  
  // Provide some feedback to the console
  
  // Return library
  return testLibrary;
}
