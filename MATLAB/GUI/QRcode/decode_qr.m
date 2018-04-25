function message = decode_qr(img)
% DECODE_QR Finds QR code and the message embedded
%  
% Given an image, locates a QR code embedded in the image, and extracts the
% string message embedded within. With slight modification this code can
% extract the structural information (see commented out ResultParser
% lines).
%
% Note that this function requires zxing (http://code.google.com/p/zxing/)
% installed, and core/core.jar, javase/javase.jar on the classpath
%
%   Parameters:
%
%       img - image containig QR code
%
%   Returns:
%
%       message - embedded message (or empty string if QR code not found)

%% AUTHOR    : Lior Shapira 
%% $DATE     : 02-Nov-2010 11:29:03 $ 
%% $Revision : 1.00 $ 
%% DEVELOPED : 7.11.0.584 (R2010b) 
%% FILENAME  : decode_qr.m 

import com.google.zxing.qrcode.QRCodeReader;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.Result;
%import com.google.zxing.client.result.ResultParser;

jimg = im2java2d(img);
source = BufferedImageLuminanceSource(jimg);

bitmap = BinaryBitmap(HybridBinarizer(source));

qr_reader = QRCodeReader;
try 
    result = qr_reader.decode(bitmap);
    %parsedResult = ResultParser.parseResult(result);
    message = char(result.getText());
catch e
    message = [];        
end

clear source;
clear jimg;
clear bitmap;

% Created with NEWFCN.m by Frank González-Morphy  
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [decode_qr.m] ======  
