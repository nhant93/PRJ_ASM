<%@page import="dao.BookDAO"%>
<%@page import="model.Users"%>
<%@page import="dao.UserDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Settings - Library</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <style>
            body {
                background-color: #ffffff;
                color: #000000;
                font-family: 'Roboto', sans-serif;
                margin: 0;
                padding: 20px;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                overflow-y: auto;
                position: relative;
            }

            /* Nút Back mới */
            .back-arrow-btn {
                display: flex;
                align-items: center;
                background: #7EDBE5;
                color: #000000;
                padding: 8px 12px;
                border-radius: 20px;
                border: 1px solid rgba(255, 255, 255, 0.1);
                font-size: 1rem;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                position: absolute;
                top: 10px;
                left: 10px;
                z-index: 1000;
            }
            .back-arrow-btn:hover {
                background: #00FF33;
                border-color: #006600;
                box-shadow: 0 4px 10px rgba(26, 115, 232, 0.2);
                transform: translateX(-2px);
            }
            .back-arrow-btn .arrow {
                margin-right: 6px;
                font-size: 1.2rem;
            }

            /* Container chính */
            .settings-container {
                background: #D8F6F8;
                color: #000000;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.5);
                width: 100%;
                max-width: 900px;
                display: flex;
                flex-direction: column;
                border: 1px solid rgba(255, 255, 255, 0.05);
            }

            /* Phần đầu chứa Settings và Search */
            .header-container {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 20px;
                width: 100%;
            }
            h1 {
                font-family: 'Roboto', sans-serif;
                font-size: 2rem;
                font-weight: 700;
                color: #000000;
                text-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
                margin: 0;
                flex-grow: 1;
                text-align: center;
            }

            /* Bố cục hai cột */
            .settings-content {
                display: flex;
                width: 100%;
            }
            .settings-menu {
                flex: 1;
                padding-right: 20px;
                border-right: 1px solid rgba(255, 255, 255, 0.1);
            }
            .settings-details-container {
                flex: 2;
                padding-left: 20px;
            }

            /* Danh sách menu (bên trái) */
            .settings-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }
            .settings-item {
                background: #A8E6EE;
                padding: 15px 20px;
                margin: 10px 0;
                border-radius: 10px;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 1.1rem;
                font-weight: 500;
                color: #252525;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
                border: 1px solid rgba(255, 255, 255, 0.05);
                text-align: left;
            }
            .settings-item:hover {
                background: #6bd4e2;
                transform: translateY(-2px);
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
            }
            .settings-item.active {
                background: #6bd4e2;
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
            }

            /* Nội dung chi tiết (bên phải) - Đồng bộ từ General Settings */
            .settings-details {
                display: none;
                margin-top: 0;
                background: #92e0ea;
                padding: 25px;
                border-radius: 10px;
                text-align: left;
                width: 100%;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
                opacity: 0;
                transform: translateY(10px);
                transition: all 0.3s ease;
                box-sizing: border-box; /* Ensure padding is included in width */
                min-width: 300px; /* Prevent the container from becoming too narrow */
            }
            .settings-details.active {
                display: block;
                opacity: 1;
                transform: translateY(0);
            }
            .settings-details h3 {
                font-size: 1.5rem; /* Tăng kích thước chữ */
                font-weight: 700; /* Tô đậm */
                color: #000000; /* Màu xanh nổi bật */
                margin-bottom: 20px; /* Tăng khoảng cách dưới */
                padding-bottom: 13px;
                border-bottom: 2px solid #000000; /* Gạch chân màu xanh */
                text-transform: uppercase; /* Chữ in hoa */
                letter-spacing: 1px; /* Khoảng cách chữ */
            }
            .detail-item {
                margin: 13px 0;
                padding: 15px;
                background-color: #D8F6F8;
                border-radius: 10px;
                border: 2px solid;
                border-color: #1D8693;
                display: flex;
                align-items: center;
                flex-wrap: wrap; /* Allow the flex items to wrap if needed */
                width: 100%; /* Ensure the detail-item takes the full width of its parent */
                box-sizing: border-box; /* Include padding and border in the element's width */
            }
            .detail-item:hover {
                background: #FFFF9C; /* Hiệu ứng hover sáng hơn */
                transform: translateX(5px); /* Dịch nhẹ sang phải khi hover */
            }
            .detail-item label {
                font-size: 1rem; /* Tăng kích thước chữ */
                font-weight: 600;
                color: #252525;
                width: auto; /* Remove fixed width to make it more flexible */
                margin: 0 10px;
                flex-shrink: 0;
            }
            .detail-item span, .detail-item input {
                font-size: 0.95rem;
                font-weight: 400;
                color: #252525;
                padding-left: 10px;
                border-radius: 10px;
                border: 0 solid;
                width: auto;
                overflow-wrap: break-word; /* Allow long text to wrap */
                word-break: break-all; /* Break long words if necessary */
                flex-grow: 1; /* Allow the span to grow to fill available space */
            }
            .detail-item input:focus {
                outline: none;
                border-color: #1a73e8;
                box-shadow: 0 0 8px rgba(26, 115, 232, 0.2);
            }

            /* Modal cho gia hạn - Giữ nguyên */
            .modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                justify-content: center;
                align-items: center;
            }
            .modal-content {
                background: #FFFFE0;
                padding: 20px;
                border-radius: 10px;
                width: 450px;
                max-width: 90%;
                text-align: left;
                position: relative;
                overflow: hidden;
            }
            .modal-content img {
                width: 100px;
                height: 150px;
                object-fit: cover;
                margin: 0 auto;
                display: block;
            }
            .modal-content h4 {
                text-align: center;
                margin: 10px 0;
            }
            .modal-btn {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
            }
            .modal-btn:hover {
                background-color: #0056b3;
            }
            .modal-content input {
                width: 100%;
                margin-top: 10px;
                margin-bottom: 10px;
                align-content: center;
            }
            .modal-content button {
                background: #1a73e8;
                color: #fff;
                border: none;
                padding: 8px 15px;
                border-radius: 5px;
                cursor: pointer;
                margin-top: 10px;
            }
            .modal-content button:hover {
                background: #1557b0;
            }
            .modal-content button:disabled {
                background: #666;
                cursor: not-allowed;
            }
            .modal-content .slide-container {
                display: flex;
                width: 100%;
            }
            .modal-content .slide {
                width: 100%;
                padding: 10px;
                box-sizing: border-box;
                display: none;
            }
            .modal-content .slide.active {
                display: block;
            }
            .modal-content .note {
                font-size: 0.9rem;
                color: #FFD700;
                margin-top: 10px;
            }
            .button-container {
                display: flex;
                justify-content: space-between;
            }
            .back-btn {
                background: #808080;
            }
            .back-btn:hover {
                background: #666666;
            }

            /* Nút Done - Đồng bộ từ General Settings */
            .done-btn {
                background: linear-gradient(135deg, #1a73e8 0%, #1557b0 100%);
                color: #ffffff;
                padding: 8px 20px;
                border: none;
                border-radius: 20px;
                font-size: 0.95rem;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 15px;
                display: inline-block;
            }

            .done-btn:not(:disabled):hover {
                background: linear-gradient(135deg, #1557b0 0%, #1a73e8 100%);
                transform: translateY(-1px);
                box-shadow: 0 4px 10px rgba(26, 115, 232, 0.4);
            }

            .done-btn:disabled {
                background: #d7dbdd;
                color: #999;
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }

            /* Hiệu ứng nháy đỏ - Giữ nguyên */
            .highlight {
                animation: flashRed 2s ease-in-out;
            }
            @keyframes flashRed {
                0% {
                    color: #ffffff;
                }
                50% {
                    color: #ff4444;
                }
                100% {
                    color: #d0d0d0;
                }
            }
            /* Thêm hiệu ứng phóng to - Giữ nguyên */
            .zoom-effect {
                animation: zoomInOut 1s ease-in-out;
            }
            @keyframes zoomInOut {
                0% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.2);
                }
                100% {
                    transform: scale(1);
                }
            }

            /* Màu sắc cho số sách mượn - Giữ nguyên */
            .book-count.green {
                color: #28a745;
            }
            .book-count.yellow {
                color: #FFD700;
            }
            .book-count.red {
                color: #dc3545;
            }
        </style>
    </head>
    <body>
        <!-- Nút Back nằm ngoài settings-container - Giữ nguyên -->
        <button class="back-arrow-btn" onclick="history.back()">
            <span class="arrow">←</span> Back
        </button>

        <div class="settings-container">
            <!-- Phần đầu chứa Settings và Search - Giữ nguyên -->
            <div class="header-container">
                <h1>Settings</h1>
            </div>

            <!-- Bố cục hai cột -->
            <div class="settings-content">
                <!-- Menu bên trái - Giữ nguyên -->
                <div class="settings-menu">
                    <ul class="settings-list">
                        <li><div class="settings-item active" data-target="account-info">Account Users</div></li>
                        <li><div class="settings-item" data-target="change-password">Change For Password</div></li>
                        <li><div class="settings-item" data-target="general-settings">General Settings</div></li>
                    </ul>
                </div>

                <!-- Nội dung chi tiết bên phải -->
                <div class="settings-details-container">
                    <!-- Tài khoản - Áp dụng giao diện từ General Settings -->
                    <div class="settings-details active" id="account-info">
                        <h3 class="searchable">Users Information</h3>
                        <div class="detail-item">
                            <label class="searchable">Username:</label>
                            <span class="searchable"><%= session.getAttribute("user") != null ? ((Users) session.getAttribute("user")).getFullname() : "N/A"%></span>
                        </div>
                        <div class="detail-item">
                            <label class="searchable">Roll Number:</label> 
                            <span class="searchable"><%= session.getAttribute("user") != null ? ((Users) session.getAttribute("user")).getRollNumber() : "N/A"%></span>
                        </div>
                        <div class="detail-item">
                            <label class="searchable">Phone Number:</label>
                            <span class="searchable"><%= session.getAttribute("user") != null ? ((Users) session.getAttribute("user")).getPhonenumber() : "N/A"%></span>
                        </div>
                        <div class="detail-item">
                            <label class="searchable">Address:</label>
                            <span class="searchable"><%= session.getAttribute("user") != null ? ((Users) session.getAttribute("user")).getAddress() : "N/A"%></span>
                        </div>
                        <div class="detail-item">
                            <label class="searchable">Email:</label>
                            <span class="searchable"><%= session.getAttribute("user") != null ? ((Users) session.getAttribute("user")).getEmail() : "N/A"%></span>
                        </div>
                    </div>

                    <!-- Modal thông báo password -->
                    <div id="customModal" class="modal">
                        <div class="modal-content">
                            <h3 id="modalTitle">Notification</h3>
                            <p id="modalMessage"></p>
                            <button onclick="closeModal()" class="modal-btn">OK</button>
                        </div>
                    </div>
                    <!-- Thay đổi mật khẩu - Áp dụng giao diện từ General Settings -->
                    <div class="settings-details" id="change-password">
                        <h3 class="searchable">Change For PassWord</h3>
                        <form id="changePasswordForm" onsubmit="return changePassword(event)">
                            <div class="detail-item">
                                <label class="searchable">Current Password:</label>
                                <input type="password" id="currentPassword" placeholder="Enter current password" class="searchable" required>
                            </div>
                            <div class="detail-item">
                                <label class="searchable">New Password:</label>
                                <input type="password" id="newPassword" placeholder="Enter new password" class="searchable" required>
                            </div>
                            <div class="detail-item">
                                <label class="searchable">Confirm New Password:</label>
                                <input type="password" id="confirmNewPassword" placeholder="Confirm new password" class="searchable" required>
                            </div>
                            <button type="submit" class="done-btn">Done</button>
                        </form>
                    </div>

                    <!-- Cài đặt chung - Giữ nguyên vì đã có giao diện chuẩn -->
                    <div class="settings-details" id="general-settings">
                        <%
                            UserDAO userDAO = new UserDAO();
                            BookDAO bookDAO = new BookDAO();
                            int userID = session.getAttribute("user") != null ? ((Users) session.getAttribute("user")).getUserID() : -1;
                            String rollNumber = session.getAttribute("user") != null ? ((Users) session.getAttribute("user")).getRollNumber() : "";
                            int lateDays = userDAO.getLateDays(userID);
                            int bookCount = userDAO.getBookCount(userID);
                            int maxBooksAllowed = userDAO.getMaxBooksAllowed();
                            int lateFeePerDay = userDAO.getLateFeePerDay();
                            int extendFee = bookDAO.getExtendFee();
                            String notificationInterval = userDAO.getNotificationInterval(rollNumber);
                        %>

                        <h3 class="searchable">Late Fee</h3>
                        <div class="detail-item">
                            <label class="searchable">The number of days you are late is:</label>
                            <span class="searchable"><%= lateDays%> Days</span>
                        </div>
                        <div class="detail-item">
                            <label class="searchable">The money you need to pay is:</label>
                            <span class="searchable"><%= (lateDays > 0 && lateFeePerDay > 0) ? (lateDays * lateFeePerDay) + " VNĐ" : "0 VNĐ"%></span>
                        </div>

                        <h3 class="searchable">Limit number of books borrowed</h3>
                        <div class="detail-item">
                            <label class="searchable">Number of books you are borrowing:</label>
                            <span class="book-count searchable <%= bookCount < 5 ? "green" : bookCount <= 8 ? "yellow" : "red"%>"><%= bookCount%> Books</span>
                        </div>
                        <div class="detail-item">
                            <label class="searchable">The remaining books you can borrow:</label>
                            <span class="searchable"><%= maxBooksAllowed - bookCount%> Books</span>
                        </div>

                        <h3 class="searchable">Book return reminder time</h3>
                        <div class="detail-item">
                            <label class="searchable">Notification to me</label>
                            <select id="notificationInterval" onchange="updateNotification()">
                                <option value="1" <%= "1".equals(notificationInterval) ? "selected" : ""%>>Accept Notification</option>
                                <option value="0" <%= "0".equals(notificationInterval) ? "selected" : ""%>>NO Accept Notificatio</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal cho gia hạn -->
            <div id="extendModal" class="modal">
                <div class="modal-content">
                    <div class="slide-container">
                        <!-- Slide 0: Xác nhận gia hạn -->
                        <div class="slide" id="extendSlide0">
                            <h4>Confirm extension</h4>
                            <p>Do you want to extend day for this book?</p>
                            <img id="modalBookImage" src="" alt="Book Image">
                            <h4 id="modalBookTitle"></h4>
                            <div class="button-container">
                                <button class="back-btn" onclick="closeModal()">Back</button>
                                <button onclick="goToDaysInput()">Confirm</button>
                            </div>
                        </div>

                        <!-- Slide 1: Nhập số ngày gia hạn -->
                        <div class="slide" id="extendSlide1">
                            <h4>Extend days</h4>
                            <div class="detail-item">
                                <label>Number of days:</label>
                                <input type="number" id="extendDays" placeholder="Enter days (<%= (extendFee / 1000)%>.000 VNĐ/day)" min="1" oninput="checkDaysInput()">
                            </div>
                            <div class="button-container">
                                <button class="back-btn" onclick="goBackFromDays()">Back</button>
                                <button id="nextBtn" onclick="showPaymentDetails()" disabled>Next</button>
                            </div>
                        </div>

                        <!-- Slide 2: Thông tin thanh toán -->
                        <div class="slide" id="extendSlide2">
                            <h4>Payment Information</h4>
                            <div style="font-size: 0.7rem; margin-bottom: 2px; padding: 4px; background: #FFFFE0; border: 2px solid #BFBFBF; border-radius: 6px; display: flex; align-items: center; justify-content: space-between;">
                                <label style="width: 110px; display: inline-block; font-weight: bold; color: #333;">Amount to Pay:</label>
                                <span id="paymentAmountDisplay" style="font-size: 0.8rem; font-weight: bold; color: #d32f2f; padding: 4px 6px; background: #fff; border-radius: 4px; border: 1px solid #d32f2f;"></span>
                                <input type="hidden" id="paymentAmount" value="100000">
                            </div>
                            <div style="font-size: 0.7rem; margin-bottom: 2px;">
                                <label style="width: 110px; display: inline-block;">Bank:</label>
                                <input type="text" id="bankname" value="VietcomBank" readonly style="font-size: 0.7rem; padding: 4px 6px;">
                            </div>
                            <div style="font-size: 0.7rem; margin-bottom: 2px;">
                                <label style="width: 110px; display: inline-block;">Account number:</label>
                                <input type="text" id="accountNumber" value="1013679489" readonly style="font-size: 0.7rem; padding: 4px 6px;">
                            </div>
                            <div style="font-size: 0.7rem; margin-bottom: 2px;">
                                <label style="width: 110px; display: inline-block;">Name:</label>
                                <input type="text" id="nameowner" value="Hong Tuan Nguyen" readonly style="font-size: 0.7rem; padding: 4px 6px;">
                            </div>
                            <div class="qr-container">
                                <h4>QR code</h4>
                                <div id="qrcode"></div>
                            </div>

                            <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script> 
                            <script>
                                    function updateQRCode() {
                                        var amount = document.getElementById("paymentAmount").value;
                                        var accountNumber = document.getElementById("accountNumber").value.trim();
                                        var namebank = document.getElementById("bankname").value.trim();
                                        var nameowner = document.getElementById("nameowner").value.trim();

                                        var qrText = "Bank: " + namebank + " \n Account: " + accountNumber + " \n Name: " + nameowner + "\nMoney : " + amount + "VND";
                                        document.getElementById("qrcode").innerHTML = "";

                                        new QRCode(document.getElementById("qrcode"), {
                                            text: qrText,
                                            correctLevel: QRCode.CorrectLevel.H
                                        });
                                        setTimeout(() => {
                                            document.querySelector("#qrcode img").style.width = "30%";
                                            document.querySelector("#qrcode img").style.height = "30%";
                                        }, 100);
                                    }
                            </script>
                            <p class="note">Please take a screenshot after completing transaction.</p>
                            <div class="button-container">
                                <button class="back-btn" onclick="goBack()">Back</button>
                                <button id="finishBtn" onclick="finishPayment()">Finish</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                                    // Đảm bảo mã chạy sau khi DOM được tải hoàn toàn - Giữ nguyên
                                    document.addEventListener('DOMContentLoaded', function () {
                                        const settingsItems = document.querySelectorAll('.settings-item');
                                        if (settingsItems.length === 0) {
                                            console.error("Element .settings-item not found!");
                                            return;
                                        }

                                        settingsItems.forEach(item => {
                                            item.addEventListener('click', function () {
                                                const targetId = this.getAttribute('data-target');
                                                const targetDetail = document.getElementById(targetId);

                                                if (!targetDetail) {
                                                    console.error(`Element with id: ${targetId} not found`);
                                                    return;
                                                }

                                                document.querySelectorAll('.settings-details').forEach(detail => {
                                                    detail.classList.remove('active');
                                                });
                                                document.querySelectorAll('.settings-item').forEach(i => {
                                                    i.classList.remove('active');
                                                });

                                                this.classList.add('active');
                                                targetDetail.classList.add('active');

                                                console.log(`Transfered to: ${targetId}`);
                                            });
                                        });

                                        // Tự động mở modal nếu có tham số action=extend
                                        const urlParams = new URLSearchParams(window.location.search);
                                        if (urlParams.get('action') === 'extend') {
                                            const title = urlParams.get('title');
                                            const image = urlParams.get('image');
                                            showExtendModal(title, image);
                                        }
                                    });

                                    // Search functionality - Giữ nguyên
                                    const searchInput = document.getElementById('searchInput');

                                    function applyZoomEffect(element) {
                                        element.classList.add('zoom-effect');
                                        setTimeout(() => {
                                            element.classList.remove('zoom-effect');
                                        }, 1000);
                                    }

                                    function handleSearch() {
                                        const searchTerm = searchInput.value.trim().toLowerCase();
                                        let found = false;

                                        document.querySelectorAll('.searchable').forEach(element => {
                                            element.style.transform = 'scale(1)';
                                            element.classList.remove('zoom-effect');
                                        });

                                        if (!searchTerm) {
                                            const accountItem = document.querySelector('.settings-item[data-target="account-info"]');
                                            const accountDetail = document.getElementById('account-info');
                                            document.querySelectorAll('.settings-item').forEach(item => item.classList.remove('active'));
                                            document.querySelectorAll('.settings-details').forEach(detail => detail.classList.remove('active'));
                                            accountItem.classList.add('active');
                                            accountDetail.classList.add('active');
                                            return;
                                        }

                                        document.querySelectorAll('.searchable').forEach(element => {
                                            const text = element.textContent.toLowerCase();
                                            if (text.includes(searchTerm)) {
                                                found = true;
                                                const parentDetail = element.closest('.settings-details');
                                                const targetId = parentDetail.id;
                                                const settingsItem = document.querySelector(`.settings-item[data-target="${targetId}"]`);

                                                document.querySelectorAll('.settings-details').forEach(detail => detail.classList.remove('active'));
                                                document.querySelectorAll('.settings-item').forEach(item => item.classList.remove('active'));
                                                parentDetail.classList.add('active');
                                                settingsItem.classList.add('active');

                                                applyZoomEffect(element);
                                            }
                                        });

                                        if (!found) {
                                            alert("No Find");
                                        }
                                    }

                                    // Change password functionality - Giữ nguyên
                                    function changePassword(event) {
                                        event.preventDefault();

                                        const currentPassword = document.getElementById('currentPassword').value;
                                        const newPassword = document.getElementById('newPassword').value;
                                        const confirmNewPassword = document.getElementById('confirmNewPassword').value;

                                        if (newPassword !== confirmNewPassword) {
                                            alert("New password doesn't match!");
                                            return false;
                                        }

                                        fetch('<%=request.getContextPath()%>/Setting', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/x-www-form-urlencoded',
                                            },
                                            body: new URLSearchParams({
                                                'rollNumber': '<%= session.getAttribute("user") != null ? ((Users) session.getAttribute("user")).getRollNumber() : ""%>',
                                                'currentPassword': currentPassword,
                                                'newPassword': newPassword,
                                                'action': 'changePassword'
                                            })
                                        })
                                                .then(response => response.text())
                                                .then(data => {
                                                    if (data === "success") {
                                                        alert("Change password successfully!");
                                                        document.getElementById('changePasswordForm').reset();
                                                    } else if (data === "wrongCurrentPassword") {
                                                        alert("Wrong current password!");
                                                    } else {
                                                        alert("Error while changing password. Please try again.");
                                                    }
                                                })
                                                .catch(error => {
                                                    console.error('Error:', error);
                                                    alert("Error while changing password. Please try again.");
                                                });

                                        return false;
                                    }

                                    // Modal và gia hạn functionality
                                    const extendModal = document.getElementById('extendModal');
                                    const slide0 = document.getElementById('extendSlide0');
                                    const slide1 = document.getElementById('extendSlide1');
                                    const slide2 = document.getElementById('extendSlide2');
                                    const nextBtn = document.getElementById('nextBtn');
                                    const finishBtn = document.getElementById('finishBtn');
                                    let currentTitle = null;
                                    let currentImage = null;

                                    function showExtendModal(title, image) {
                                        currentTitle = title || '<%= request.getAttribute("title") != null ? request.getAttribute("title") : ""%>';
                                        currentImage = image || '<%= request.getAttribute("image") != null ? request.getAttribute("image") : ""%>';
                                        extendModal.style.display = 'flex';
                                        if (currentTitle && currentImage) {
                                            document.getElementById('modalBookTitle').textContent = currentTitle;
                                            document.getElementById('modalBookImage').src = '<%=request.getContextPath()%>/book/BookImage/' + currentImage;
                                            slide0.classList.add('active');
                                            slide1.classList.remove('active');
                                            slide2.classList.remove('active');
                                        } else {
                                            slide0.classList.remove('active');
                                            slide1.classList.add('active');
                                            slide2.classList.remove('active');
                                        }
                                        document.getElementById('extendDays').value = '';
                                        nextBtn.disabled = true;
                                        finishBtn.disabled = true;
                                    }

                                    function closeModal() {
                                        extendModal.style.display = 'none';
                                        currentTitle = null;
                                        currentImage = null;
                                    }

                                    function goToDaysInput() {
                                        slide0.classList.remove('active');
                                        slide1.classList.add('active');
                                    }

                                    function goBackFromDays() {
                                        if (currentTitle && currentImage) {
                                            slide1.classList.remove('active');
                                            slide0.classList.add('active');
                                        } else {
                                            closeModal();
                                        }
                                    }

                                    function checkDaysInput() {
                                        const days = document.getElementById('extendDays').value;
                                        nextBtn.disabled = !days || days <= 0;
                                    }

                                    const extendFee = <%= extendFee%>;
                                    function showPaymentDetails() {
                                        const days = parseInt(document.getElementById('extendDays').value, 10);
                                        if (isNaN(days) || days <= 0) {
                                            alert("Please enter valid days!");
                                            return;
                                        }

                                        const fee = days * extendFee;

                                        document.getElementById("paymentAmount").value = fee;
                                        document.getElementById("paymentAmountDisplay").textContent = fee.toLocaleString('vi-VN') + " VNĐ";

                                        slide1.classList.remove('active');
                                        slide2.classList.add('active');
                                        updateQRCode();
                                        finishBtn.disabled = false;
                                    }

                                    function goBack() {
                                        slide2.classList.remove('active');
                                        slide1.classList.add('active');
                                        finishBtn.disabled = true;
                                    }

                                    function finishPayment() {
                                        const days = parseInt(document.getElementById('extendDays').value, 10);
                                        const rollNumber = '<%= session.getAttribute("user") != null ? ((Users) session.getAttribute("user")).getRollNumber() : ""%>';

                                        if (isNaN(days) || days <= 0) {
                                            alert("Please enter a valid number of days.");
                                            return;
                                        }

                                        const params = new URLSearchParams({
                                            'rollNumber': rollNumber,
                                            'extendDays': days,
                                            'title': currentTitle
                                        });

                                        fetch('<%=request.getContextPath()%>/ExtendLoanServlet', {
                                            method: 'POST',
                                            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                            body: params
                                        })
                                                .then(response => response.text())
                                                .then(data => {
                                                    console.log("Response from ExtendLoanServlet:", data);
                                                    if (data === "success") {
                                                        alert("Extension successful! Please take a screenshot as proof.");
                                                        closeModal();
                                                        window.location.href = '<%=request.getContextPath()%>/Borrow';
                                                    } else {
                                                        alert("Error extending loan. Please try again. Error code: " + data);
                                                    }
                                                })
                                                .catch(error => {
                                                    console.error('Error:', error);
                                                    alert("Error extending loan. Please try again. Details: " + error.message);
                                                    closeModal();
                                                });
                                    }

                                    // Update notification interval - Giữ nguyên
                                    function updateNotification() {
                                        const interval = document.getElementById('notificationInterval').value;
                                        const rollNumber = '<%= session.getAttribute("user") != null ? ((Users) session.getAttribute("user")).getRollNumber() : ""%>';
                                        fetch('<%=request.getContextPath()%>/UpdateNotificationServlet', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/x-www-form-urlencoded',
                                            },
                                            body: new URLSearchParams({
                                                'rollNumber': rollNumber,
                                                'interval': interval
                                            })
                                        })
                                                .then(response => response.text())
                                                .then(data => {
                                                    if (data === "success") {
                                                        alert("Reminder time update Successful!");
                                                    } else {
                                                        alert("Reminder time update Successful!");
                                                    }
                                                })
                                                .catch(error => {
                                                    console.error('Error:', error);
                                                    alert("ERROR: Reminder time update fail");
                                                });
                                    }
                                    ;
            </script>
    </body>
</html>