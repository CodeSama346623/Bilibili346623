%% Test QR encoding and decoding
%
% Please download and build the core and javase parts of zxing
% from here - http://code.google.com/p/zxing/
%
javaaddpath('core-3.3.2.jar');
javaaddpath('javase-3.3.2.jar');

% encode a new QR code
test_encode = encode_qr('la la la', [32 32]);
figure;imagesc(test_encode);axis image;
imwrite(uint8(~test_encode*255),'test_qr.jpg')
% decode
message = decode_qr(imread('test_qr.jpg'));
title(message)

