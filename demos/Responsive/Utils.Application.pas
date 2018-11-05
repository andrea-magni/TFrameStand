unit Utils.Application;

interface

uses
  Classes, SysUtils, System.Messaging
;

type
  TMainActivity = (maDashboard, maOrders);

  TSwitchToMessage = class(TMessage<TMainActivity>)
  private
  protected
  public
    type TListener = reference to procedure (const AActivity: TMainActivity; const ASender: TObject);
    class procedure Send(const AActivity: TMainActivity; const ASender: TObject = nil);
    class function Subscribe(const AListener: TListener): Integer;
    class procedure Unsubscribe(const AId: Integer);
  end;

  TKeyInfo = record
    KeyW: Word;
    KeyC: Char;
    Shift: TShiftState;
    constructor Create(const AKeyW: Word; const AKeyC: Char; const AShift: TShiftState);
  end;

  TKeyMessage = class(TMessage<TKeyInfo>)
  private
  protected
  public
    type TListener = reference to procedure (const AKeyInfo: TKeyInfo);
    class procedure Send(const AKeyInfo: TKeyInfo);
    class function Subscribe(const AListener: TListener): Integer;
    class procedure Unsubscribe(const AId: Integer);
  end;


implementation

{ TSwitchToMessage }

class procedure TSwitchToMessage.Send(const AActivity: TMainActivity; const ASender: TObject = nil);
begin
  TMessageManager.DefaultManager.SendMessage(
    ASender
  , TSwitchToMessage.Create(AActivity)
  );
end;

class function TSwitchToMessage.Subscribe(
  const AListener: TListener): Integer;
begin
  if not Assigned(AListener) then
    Exit(-1);

  Result := TMessageManager.DefaultManager.SubscribeToMessage(TSwitchToMessage
  , procedure(const Sender: TObject; const M: TMessage)
    begin
      AListener((M as TSwitchToMessage).Value, Sender);
    end
  );
end;

class procedure TSwitchToMessage.Unsubscribe(const AId: Integer);
begin
  TMessageManager.DefaultManager.Unsubscribe(TSwitchToMessage, AId);
end;

{ TKeyInfo }

constructor TKeyInfo.Create(const AKeyW: Word; const AKeyC: Char;
  const AShift: TShiftState);
begin
  KeyW := AKeyW;
  KeyC := AKeyC;
  Shift := AShift;
end;

{ TKeyMessage }

class procedure TKeyMessage.Send(const AKeyInfo: TKeyInfo);
begin
  TMessageManager.DefaultManager.SendMessage(nil
  , TKeyMessage.Create(AKeyInfo)
  );
end;

class function TKeyMessage.Subscribe(const AListener: TListener): Integer;
begin
  if not Assigned(AListener) then
    Exit(-1);

  Result := TMessageManager.DefaultManager.SubscribeToMessage(TKeyMessage
  , procedure(const Sender: TObject; const M: TMessage)
    begin
      AListener((M as TKeyMessage).Value);
    end
  );
end;

class procedure TKeyMessage.Unsubscribe(const AId: Integer);
begin
  TMessageManager.DefaultManager.Unsubscribe(TKeyMessage, AId);
end;

end.
