program calculator;

uses Crt;

var
  num1, num2, result: Real;
  mathOperator: Char;

// Procedure to display the menu
procedure ShowMenu;
begin
  ClrScr;
  WriteLn('--- Pascal Calculator ---');
  WriteLn('Enter the first number: ');
  ReadLn(num1);

  WriteLn('Enter the operator (+, -, *, /): ');
  ReadLn(mathOperator);

  WriteLn('Enter the second number: ');
  ReadLn(num2);
end;

// Function to perform addition
function Add(a, b: Real): Real;
begin
  Add := a + b;
end;

// Function to perform subtraction
function Subtract(a, b: Real): Real;
begin
  Subtract := a - b;
end;

// Function to perform multiplication
function Multiply(a, b: Real): Real;
begin
  Multiply := a * b;
end;

// Function to perform division
function Divide(a, b: Real): Real;
begin
  if b <> 0 then
    Divide := a / b
  else
  begin
    WriteLn('Error: Division by zero!');
    Divide := 0; // Or handle error appropriately
  end;
end;

// Main program logic
begin
  ShowMenu;

  case mathOperator of
    '+': result := Add(num1, num2);
    '-': result := Subtract(num1, num2);
    '*': result := Multiply(num1, num2);
    '/': result := Divide(num1, num2);
  else
    WriteLn('Invalid operator entered!');
  end;

  // Display the result if no division by zero error occurred
  if (mathOperator = '/') and (num2 = 0) then
  begin
    // Error message already displayed in Divide function
    WriteLn('Press Enter to exit...');
  end
  else
  begin
    WriteLn('Result: ', result:0:2); // Display result with 2 decimal places
    WriteLn('Press Enter to exit...');
  end;

  ReadLn; // Wait for user to press Enter
end.
