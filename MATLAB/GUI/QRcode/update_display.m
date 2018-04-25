     function update_display(obj,event,hImage)

set(hImage, 'CData', event.Data);

%  subplot(1,2,2);
message = decode_qr(event.Data);
title(message)


drawnow