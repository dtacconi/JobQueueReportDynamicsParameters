pageextension 50104 "JobQueueEntryExt" extends "Job Queue Entry Card"
{    
    actions
    {
        addafter(ReportRequestPage)
        {
            action(ShowXMLParams)
            {
                Caption = 'Show Request Page in XML format';
                Image = XMLFile;
                ApplicationArea = All;
                
                trigger OnAction()
                var
                    xmlDoc : XmlDocument;
                    rootElement: XmlElement;
                    inStr : InStream;
                    xmlParams : Text;
                begin
                    if Rec."Object Type to Run" <> Rec."Object Type to Run"::Report then
                        exit;
                    Rec.CalcFields(XML);
                    if Rec.XML.HasValue() then begin
                        Rec.XML.CreateInStream(InStr, TEXTENCODING::UTF8);
                        InStr.Read(xmlParams);
                        
                        if not XmlDocument.ReadFrom(xmlParams, xmlDoc) then
                            exit;
                        if not xmlDoc.GetRoot(rootElement) then
                            exit;
                        
                        Message(Format(xmlParams));
                    end;                    
                end;
            }
        }

    }    
}