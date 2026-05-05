# Report 1 page - Lab 4 DES / TripleDES

## Mục tiêu
Mục tiêu của bài lab là nắm bắt sâu kiến trúc và cơ chế hoạt động của thuật toán mã hóa đối xứng khối DES và biến thể nâng cao TripleDES. Thông qua việc trực tiếp triển khai code bằng C++, yêu cầu đặt ra là có thể thực hiện thành công mã hóa và giải mã (round-trip), quản lý đệm bit (zero-padding), xử lý đa khối (multi-block), đồng thời đánh giá được tính nhạy cảm của hệ mật thông qua các Negative Tests.

## Phân tích quy trình hoạt động của DES (Trả lời Q1)
Dựa trên việc phân tích luồng thực thi của chương trình `des.cpp`, thuật toán DES hoạt động theo quy trình sau:
- **Cơ chế sinh Round Keys:** Khóa đầu vào 64-bit qua bảng hoán vị PC1 để thu về 56-bit hiệu dụng. Khóa này bị chia làm 2 nửa Left và Right (mỗi nửa 28-bit). Qua 16 vòng, mỗi nửa được dịch trái. Sau mỗi bước dịch, hai nửa ghép lại thành 56-bit và đi qua bảng PC2 để trích xuất khóa vòng (round key) dài 48-bit.
- **Dữ liệu qua IP:** Chuỗi plaintext 64-bit đầu vào được đi qua hàm hoán vị IP để xáo trộn vị trí các bit.
- **Cơ chế chia nửa:** Khối 64-bit sau khi qua IP bị xẻ đôi thành: Left (32-bit) và Right (32-bit).
- **Vai trò của các vòng Feistel:** Lặp lại 16 lần. Ở mỗi vòng, nửa Right được mở rộng từ 32-bit lên 48-bit để XOR với khóa vòng 48-bit. Kết quả XOR được đưa qua 8 hộp S-box để ép xuống còn 32-bit. Kết quả này đi qua hoán vị P và XOR với nửa Left. Kết thúc vòng, Left và Right đổi vị trí cho nhau.
- **Vai trò của hoán vị ngược (Inverse IP):** Sau vòng 16, hai nửa được ghép trực tiếp (Right + Left) rồi đưa qua hoán vị IP^-1. Dùng hoán vị ngược cho phép quá trình giải mã tái sử dụng hoàn toàn bộ máy mã hóa này, chỉ cần nạp khóa vòng theo thứ tự đảo ngược.

## Cách làm / Method
Từ repository khởi tạo ban đầu, thuật toán DES đã được tái cấu trúc:
- **Tích hợp giải mã (Decryption):** Tái sử dụng mạng Feistel nhưng đảo ngược thứ tự áp dụng 16 round keys.
- **Hỗ trợ Multi-block và Padding:** Tạo hàm `pad_input` thực hiện zero padding. Hàm xử lý chính sẽ cắt chuỗi theo từng block 64-bit.
- **Tích hợp TripleDES:** Tuân theo chuẩn E-D-E cho mã hóa và đảo ngược D-E-D cho giải mã.
- **Giao tiếp I/O chuẩn hóa:** Viết lại khối `main` để chương trình nhận đúng 4 Mode hoạt động qua `stdin`.

## Kết quả / Result
Hệ thống hoàn thành toàn bộ yêu cầu:
- Chuỗi bit nguyên bản vượt qua được vòng lặp mã hóa - giải mã (Round-trip test).
- Multi-block test phân mảnh chuẩn xác một chuỗi bit dài ngẫu nhiên và hoàn tác thành công.
- Tamper Test chứng minh đặc tính khuếch tán: lật 1 bit của Ciphertext làm block 64-bit giải mã bị hỏng hoàn toàn.
- Wrong Key Test khẳng định hệ mã hóa an toàn trước các key sai.

## Kết luận / Conclusion
Thuật toán DES mang lại nền tảng tư duy tốt về mạng Feistel, S-Box và Permutation. Nhược điểm của Zero Padding là nếu văn bản gốc có các bit `0` ở cuối, lúc giải mã ta không phân biệt được đâu là dữ liệu gốc, đâu là padding.