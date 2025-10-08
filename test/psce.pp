program psce;
//enhanced with compiler messages to the shell and output to shell
//bytecode and dissasembly output
//jan 2011 www.softwareschule.ch/maxbox.htm, loc's =218
{$APPTYPE CONSOLE}

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

uses
  SysUtils,
  Classes,
  Forms,
  uPSCompiler,
  uPSR_std,
  uPSC_std,
  uPSR_classes,
  uPSC_classes,
  uPSC_controls,
  uPSR_controls,
  uPSC_forms,
  uPSR_forms,
  uPSRuntime,
  uPSComponent,
  uPSDisassembly,
  uPSR_dateutils,
  uPSC_dateutils,
  uPSR_dll,
  uPSC_dll;

type
  TPSCE = class
   protected
    FScr: TPSScript;
    procedure SaveCompiled(var Data: String);
    procedure SaveDissasembly(var Data: String);
    procedure OnCompile(Sender: TPSScript);
    procedure OnExecImport(Sender: TObject; se: TPSExec;
                                   x: TPSRuntimeClassImporter);
   public
    constructor Create;
    destructor Destroy; override;
    function Compile(const FileName: string): Boolean;
    function Execute: Boolean;
  end;


var
  aPSCE: TPSCE;
  SFile, sData: String;


procedure MWritedt(d : TDateTime);
var
 s: String;
begin
  s:= DateToStr(d) + ' ' + TimeToStr(d);
  Write(s);
end;


procedure MWrites(const s: string);
begin
  Write(s);
end;

procedure MWritei(const i: Integer);
begin
  Write(i);
end;

procedure MWrited(const d: Double);
begin
  Write(d:0:1);
end;

procedure MWriteln;
begin
  Writeln;
end;

procedure MyVal(const s: string; var n, z: Integer);
begin
  Val(s, n, z);
end;

constructor TPSCE.Create;
begin
  FScr:= TPSScript.Create(nil);
  FScr.OnCompile:= OnCompile;
  FScr.OnExecImport:= OnExecImport;
end;

destructor TPSCE.Destroy;
begin
  FScr.Free;
end;

procedure TPSCE.SaveCompiled(var Data : String);
var
  OutFile: string;
  Fx: Longint ;
begin
  OutFile:= ExtractFilePath(ParamStr(0)) + ChangeFileExt(SFile,'.out');
  Fx:= FileCreate(OutFile) ;
  FileWrite(Fx,Data[1],Length(Data));
  FileClose(Fx) ;
end;

procedure TPSCE.SaveDissasembly(var Data: String);
var
  OutFile: string;
  Fx: Longint ;
begin
  OutFile:= ExtractFilePath(ParamStr(0)) + ChangeFileExt(SFile,'.dis');
  Fx:= FileCreate(OutFile) ;
  FileWrite(Fx, Data[1], Length(Data));
  FileClose(Fx) ;
end;


procedure TPSCE.OnExecImport(Sender: TObject; se: TPSExec; x: TPSRuntimeClassImporter);
begin
  RIRegister_Std(x);
  RIRegister_Classes(x,true);
  RIRegister_Controls(x);
  RIRegister_Forms(x);
  RegisterDateTimeLibrary_R(se);
  RegisterDLLRuntime(se);
end;

procedure TPSCE.OnCompile(Sender: TPSScript);
begin
  RegisterDateTimeLibrary_C(Sender.Comp);
  Sender.AddFunction(@MWrites, 'procedure Writes(const s: string)');
  Sender.AddFunction(@MWritedt,'procedure WriteDT(d : TDateTime)');
  Sender.AddFunction(@MWritei, 'procedure Writei(const i: Integer)');
  Sender.AddFunction(@MWrited, 'procedure Writed(const f: Double)');
  Sender.AddFunction(@MWriteln, 'procedure Writeln');
  Sender.AddFunction(@MyVal, 'procedure Val(const s: string; var n, z: Integer)');
  Sender.AddFunction(@FileCreate, 'Function FileCreate(const FileName: string): integer)');
  Sender.AddFunction(@FileWrite, 'function FileWrite(Handle: Integer; const Buffer: pChar; Count: LongWord): Integer)');
  Sender.AddFunction(@FileClose, 'Procedure FileClose(handle: integer)');
  //Sender.AddRegisteredVariable('Application', 'TApplication');
  SIRegister_Std(Sender.Comp);
  SIRegister_Classes(Sender.Comp,true);
  SIRegister_Controls(Sender.Comp);
  SIRegister_Forms(Sender.Comp);
end;


function TPSCE.Compile(const FileName: string): Boolean;
var
  S: TStringList;
  i: Integer;
begin
  Result:= False;
  if FileExists(FileName) then begin
    S:= TStringList.Create;
    S.LoadFromFile(FileName);
    FScr.Script:= S;
    Result:= FScr.Compile;
    for i:= 0 to aPSCE.FScr.CompilerMessageCount - 1 do
      writeln(aPSCE.FScr.CompilerMessages[i].MessageToString);
    S.Free;
    if not Result then
      if FScr.CompilerMessageCount > 0 then
        for i:= 0 to FScr.CompilerMessageCount-1 do
          Writeln(FScr.CompilerErrorToStr(i));
      end else Writeln('Script File not found: ', FileName);
end;

function TPSCE.Execute: Boolean;
begin
  //FScr.SetVarToInstance('APPLICATION', Application);
  //FScr.SetVarToInstance('SELF', Self);
  Result:= FScr.Execute;
  //writeln(FScr.About);
  if not Result then
    Writeln('Run-time error:' + FScr.ExecErrorToString);
end;


begin  //main
  Application.Initialize;
  aPSCE:= TPSCE.Create;
  if ParamCount = 0 then begin
    Writeln('Usage: ', ExtractFileName(ParamStr(0)), ' [--compile|--dissasembly] <script.pss>');
    Writeln('');
    Writeln('--compile : Save compiled script bytecode');
    Writeln('--dissasembly: Save dissasembly of script');
    Exit;
  end;
 SFile:= ParamStr(1);
 if (ParamStr(1)='--compile') or (ParamStr(1)='--dissasembly') then begin
  SFile:= ParamStr(2);
  aPSCE.Compile(SFile);
  aPSCE.Execute;   //output on shell
  aPSCE.FScr.GetCompiled(sData);
  if Paramstr(1)='--compile' then begin
    aPSCE.FScr.Comp.GetOutput(sData);
    aPSCE.SaveCompiled(sData);
  end;
  if Paramstr(1)='--dissasembly' then begin
    aPSCE.FScr.GetCompiled(sData);
    if not IFPS3DataToText(sData, sData)
      then begin
        Writeln('Create or create not dissasembly!');
        aPSCE.SaveDissasembly(sData);  //do it anyway
    end else
    aPSCE.SaveDissasembly(sData);
  end;
  Exit;
 end;
 aPSCE.Compile(SFile);
 aPSCE.Execute;
 aPSCE.Free;
end.
