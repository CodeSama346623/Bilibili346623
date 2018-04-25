function qr = encode_qr(message, s)
% ENCODE_QR create a 2D QR code containing a message
%  
% This function creates a QR code containing a string message. The QR code
% can be of varying sizes.
%
% Note that this function requires zxing (http://code.google.com/p/zxing/)
% installed, and core/core.jar, javase/javase.jar on the classpath
%
%   Parameters:
%
%       message - string containing message
%       s       - width and height of the QR code
%
%   Returns:
%
%       qr - logical matrix of size s containing the QR code

%% AUTHOR    : Lior Shapira 
%% $DATE     : 02-Nov-2010 11:20:45 $ 
%% $Revision : 1.00 $ 
%% DEVELOPED : 7.11.0.584 (R2010b) 
%% FILENAME  : encode_qr.m 

import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.BarcodeFormat;

% encoding qr
qr_writer = QRCodeWriter;
M_java = qr_writer.encode(message, BarcodeFormat.QR_CODE, s(2), s(1));
qr = zeros(M_java.getHeight(), M_java.getWidth());
for i=1:M_java.getHeight()
    for j=1:M_java.getWidth()
        qr(i,j) = M_java.get(j-1,i-1);
    end
end

clear qr_writer;
clear M_java;

qr = logical(qr);

% Created with NEWFCN.m by Frank González-Morphy  
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [encode_qr.m] ======  
