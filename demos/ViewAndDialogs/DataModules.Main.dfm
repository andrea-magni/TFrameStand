object MainDataModule: TMainDataModule
  OldCreateOrder = False
  Height = 273
  Width = 342
  object PrototypeBindSource1: TPrototypeBindSource
    AutoActivate = True
    AutoPost = False
    FieldDefs = <
      item
        Name = 'ContactName1'
        Generator = 'ContactNames'
        ReadOnly = False
      end
      item
        Name = 'ContactTitle1'
        Generator = 'ContactTitles'
        ReadOnly = False
      end
      item
        Name = 'ContactBitmap1'
        FieldType = ftBitmap
        Generator = 'ContactBitmaps'
        ReadOnly = False
      end
      item
        Name = 'ContactBitmapL1'
        FieldType = ftBitmap
        Generator = 'ContactBitmapsL'
        ReadOnly = False
      end
      item
        Name = 'BoolField1'
        FieldType = ftBoolean
        Generator = 'Booleans'
        ReadOnly = False
      end
      item
        Name = 'LoremIpsum1'
        Generator = 'LoremIpsum'
        ReadOnly = False
      end>
    ScopeMappings = <>
    Left = 63
    Top = 54
  end
end
