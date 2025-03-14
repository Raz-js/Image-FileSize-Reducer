// Program by Raz

unit ImgComp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    TrackBar1: TTrackBar;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    btnOpenImage: TButton;
    btnCompressImage: TButton;
    btnSaveImage: TButton;
    Label1: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    procedure btnOpenImageClick(Sender: TObject);
    procedure btnCompressImageClick(Sender: TObject);
    procedure btnSaveImageClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { Private declarations }
    FOriginalFileName: string;
    FCompressedImage: TPicture;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnOpenImageClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenDialog1.FileName);
    Image3.Picture.LoadFromFile(OpenDialog1.FileName);
    FOriginalFileName := OpenDialog1.FileName;
  end;
end;

procedure TForm1.btnCompressImageClick(Sender: TObject);
var
  PNGImage: TPngImage;
  JPEGImage: TJPEGImage;
  Bitmap: TBitmap;
begin
  if FOriginalFileName = '' then
  begin
    ShowMessage('Please open an image first.');
    Exit;
  end;

  if SameText(ExtractFileExt(FOriginalFileName), '.png') then
  begin
    PNGImage := TPngImage.Create;
    try
      PNGImage.LoadFromFile(FOriginalFileName);
      Image2.Picture.Assign(PNGImage);

      if Assigned(FCompressedImage) then
        FCompressedImage.Free;
      FCompressedImage := TPicture.Create;
      FCompressedImage.Assign(PNGImage);
    finally
      PNGImage.Free;
    end;
  end
  else if SameText(ExtractFileExt(FOriginalFileName), '.jpg') or SameText(ExtractFileExt(FOriginalFileName), '.jpeg') then
  begin
    JPEGImage := TJPEGImage.Create;
    Bitmap := TBitmap.Create;
    try
      Bitmap.LoadFromFile(FOriginalFileName);
      JPEGImage.Assign(Bitmap);
      JPEGImage.CompressionQuality := TrackBar1.Position;
      Image2.Picture.Assign(JPEGImage);

      if Assigned(FCompressedImage) then
        FCompressedImage.Free;
      FCompressedImage := TPicture.Create;
      FCompressedImage.Assign(JPEGImage);
    finally
      JPEGImage.Free;
      Bitmap.Free;
    end;
  end
  else
  begin
    ShowMessage('Unsupported image format. Please use PNG or JPEG.');
    Exit;
  end;
end;

procedure TForm1.btnSaveImageClick(Sender: TObject);
var
  SaveFileName: string;
  Ext: string;
begin
  if FOriginalFileName = '' then
  begin
    ShowMessage('Please open an image first.');
    Exit;
  end;

  if not Assigned(FCompressedImage) then
  begin
    ShowMessage('Please compress the image first.');
    Exit;
  end;

  Ext := ExtractFileExt(FOriginalFileName);
  SaveFileName := ChangeFileExt(FOriginalFileName, '') + '-compressed' + Ext;

  if SameText(Ext, '.png') then
  begin
    FCompressedImage.Graphic.SaveToFile(SaveFileName);
  end
  else if SameText(Ext, '.jpg') or SameText(Ext, '.jpeg') then
  begin
    FCompressedImage.Graphic.SaveToFile(SaveFileName);
  end
  else
  begin
    ShowMessage('Unsupported image format. Please use PNG or JPEG.');
    Exit;
  end;

  ShowMessage('Image saved as: ' + SaveFileName);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  Label1.Caption := 'Compression Quality: ' + IntToStr(TrackBar1.Position);
end;

end.
