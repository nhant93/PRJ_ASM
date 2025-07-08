<%@page import="model.NotificationSettings"%>
<%@page import="java.util.List"%>
<%@page import="model.Users"%>
<%@page import="dao.UserDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.lineicons.com/4.0/lineicons.css" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: "Poppins", sans-serif; }
        body { background-color: #fff; display: flex; justify-content: center; align-items: flex-start; min-height: 100vh; padding: 20px; }
        .container { width: 100%; max-width: 1200px; background-color: #fff; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); display: flex; flex-direction: column; }
        .header { display: flex; justify-content: space-between; align-items: center; padding: 15px 20px; border-bottom: 1px solid #ddd; position: relative; }
        .header .title { font-size: 30px; font-weight: 700; color: #333; position: absolute; left: 50%; transform: translateX(-50%); }
        .logout-btn { position: absolute; top: 10px; right: 20px; color: #333; text-decoration: none; font-size: 14px; padding: 8px 16px; border-radius: 5px; transition: all 0.3s ease; }
        .logout-btn:hover { background-color: #dc3545; color: #fff; }
        .logout-btn i { margin-right: 5px; }
        .sidebar { width: 300px; background-color: #fff; padding: 20px; border-right: 1px solid #ddd; }
        .sidebar .menu { list-style: none; }
        .sidebar .menu li { margin-bottom: 10px; }
        .sidebar .menu li a { text-decoration: none; color: #333; font-size: 18px; font-weight: 700; padding: 12px 15px; border-radius: 8px; display: block; background-color: #f0f0f0; transition: all 0.3s ease; }
        .sidebar .menu li a:hover, .sidebar .menu li a.active { background-color: #6c757d; color: #fff; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2); }
        .content { flex-grow: 1; padding: 20px; }
        .search-bar { width: 100%; max-width: 500px; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px; margin-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f8f9fa; }
        .action-btn { padding: 5px 10px; border: none; border-radius: 5px; cursor: pointer; color: #fff; }
        .edit-btn { background-color: #007bff; }
        .delete-btn { background-color: #dc3545; }
        .form-group { margin-bottom: 15px; width: 100%; max-width: 300px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 5px; }
        .form-group button { padding: 10px 20px; background-color: #4bb6b7; color: #fff; border: none; border-radius: 5px; cursor: pointer; }
        .form-group button:hover { background-color: #2e6a6b; }
        .error-message { color: red; font-size: 12px; display: none; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); justify-content: center; align-items: center; }
        .modal-content { background-color: #fff; padding: 20px; border-radius: 5px; text-align: center; width: 300px; }
        .modal-content button { padding: 10px 20px; margin: 10px; border: none; border-radius: 5px; cursor: pointer; }
        .modal-content .confirm-btn { background-color: #dc3545; color: #fff; }
        .modal-content .cancel-btn { background-color: #6c757d; color: #fff; }
        #add-customer, #settings, #notification-settings { display: none; flex-direction: column; align-items: center; }
        #add-customer h3, #settings h3, #notification-settings h3 { margin-bottom: 30px; text-align: center; font-size: 24px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <span class="title">Admin</span>
            <a href="Logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Log out</a>
        </div>
        <div style="display: flex;">
            <div class="sidebar">
                <ul class="menu">
                    <li><a href="#customer-info" class="active">Customer Information</a></li>
                    <li><a href="#add-customer">Add New Customer</a></li>
                    <li><a href="#ManageBook">ManageBook</a></li>
                    <li><a href="#settings">General Settings</a></li>
                    <li><a href="#notification-settings">Notification Settings</a></li>
                </ul>
            </div>
            <div class="content">
                <div id="customer-info">
                    <h3>Customer Information</h3>
                    <input type="text" class="search-bar" placeholder="Search User..." onkeyup="searchUser()">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Roll Number</th>
                                <th>Name</th>
                                <th>Phone</th>
                                <th>Address</th>
                                <th>Email</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<Users> userList = (List<Users>) request.getAttribute("userList");
                                if (userList != null && !userList.isEmpty()) {
                                    for (Users user : userList) {
                            %>
                            <tr>
                                <td><%= user.getUserID() %></td>
                                <td><%= user.getRollNumber() != null ? user.getRollNumber() : "N/A" %></td>
                                <td><%= user.getFullname() != null ? user.getFullname() : "N/A" %></td>
                                <td><%= user.getPhonenumber() != null ? user.getPhonenumber() : "N/A" %></td>
                                <td><%= user.getAddress() != null ? user.getAddress() : "N/A" %></td>
                                <td><%= user.getEmail() != null ? user.getEmail() : "N/A" %></td>
                                <td>
                                    <button class="action-btn edit-btn" onclick="showEditModal('<%= user.getUserID() %>', '<%= user.getRollNumber() != null ? user.getRollNumber() : "" %>', '<%= user.getFullname() != null ? user.getFullname() : "" %>', '<%= user.getPhonenumber() != null ? user.getPhonenumber() : "" %>', '<%= user.getAddress() != null ? user.getAddress() : "" %>', '<%= user.getEmail() != null ? user.getEmail() : "" %>')">Edit</button>
                                    <button class="action-btn delete-btn" onclick="showDeleteModal('<%= user.getUserID() %>')">Delete</button>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else {
                            %>
                            <tr><td colspan="7">No users found.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <div id="add-customer">
                    <h3>Add New Customer</h3>
                    <form id="addCustomerForm">
                        <div class="form-group">
                            <label>Roll Number</label>
                            <input type="text" name="rollNumber" required>
                            <span id="rollNumberError" class="error-message"></span>
                        </div>
                        <div class="form-group">
                            <label>Password</label>
                            <input type="password" name="password" required>
                            <span id="passwordError" class="error-message"></span>
                        </div>
                        <div class="form-group">
                            <label>Name</label>
                            <input type="text" name="fullName" required>
                            <span id="fullNameError" class="error-message"></span>
                        </div>
                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="text" name="phoneNumber">
                        </div>
                        <div class="form-group">
                            <label>Address</label>
                            <input type="text" name="address">
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" required>
                            <span id="emailError" class="error-message"></span>
                        </div>
                        <div class="form-group">
                            <button type="submit">Add</button>
                        </div>
                    </form>
                </div>

                <div id="settings">
                    <h3>General Settings</h3>
                    <form id="settingsForm">
                        <div class="form-group">
                            <label>Default Loan Period (days)</label>
                            <input type="number" name="defaultLoanDays" min="0" value="<%= request.getAttribute("defaultLoanDays") != null ? request.getAttribute("defaultLoanDays") : 14 %>" required>
                        </div>
                        <div class="form-group">
                            <label>Max Books Allowed</label>
                            <input type="number" name="maxBooksAllowed" min="0" value="<%= request.getAttribute("maxBooksAllowed") != null ? request.getAttribute("maxBooksAllowed") : 5 %>" required>
                        </div>
                        <div class="form-group">
                            <label>Renewal Fee Per Day (VND)</label>
                            <input type="number" name="extendFee" min="0" value="<%= request.getAttribute("extendFee") != null ? request.getAttribute("extendFee") : 5 %>" required>
                        </div>
                        <div class="form-group">
                            <label>Late Fee Per Day (VND)</label>
                            <input type="number" name="lateFeePerDay" min="0" value="<%= request.getAttribute("lateFeePerDay") != null ? request.getAttribute("lateFeePerDay") : 5000 %>" required>
                        </div>
                        <div class="form-group">
                            <button type="submit">Update</button>
                        </div>
                    </form>
                </div>

                <div id="notification-settings">
                    <h3>Notification Settings</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>UserID</th>
                                <th>Roll Number</th>
                                <th>Interval (hours)</th>
                                <th>Enabled</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (userList != null && !userList.isEmpty()) {
                                    UserDAO userDAO = new UserDAO();
                                    for (Users user : userList) {
                                        NotificationSettings settings = userDAO.getNotificationSettings(user.getRollNumber());
                                        if (settings != null) {
                            %>
                            <tr>
                                <td><%= user.getUserID() %></td>
                                <td><%= user.getRollNumber() != null ? user.getRollNumber() : "N/A" %></td>
                                <td><input type="text" id="interval_<%= user.getRollNumber() %>" value="<%= settings.getNotificationInterval() %>"></td>
                                <td><input type="checkbox" id="enabled_<%= user.getRollNumber() %>" <%= settings.isEnabled() ? "checked" : "" %>></td>
                                <td><button class="action-btn edit-btn" onclick="updateNotification('<%= user.getRollNumber() %>')">Update</button></td>
                            </tr>
                            <% 
                                        }
                                    }
                                } else {
                            %>
                            <tr><td colspan="5">No settings found.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="editModal" class="modal">
        <div class="modal-content">
            <h3>Edit Customer</h3>
            <form id="editUserForm">
                <input type="hidden" name="userID" id="editUserID">
                <div class="form-group">
                    <label>Roll Number</label>
                    <input type="text" name="rollNumber" id="editRollNumber" required>
                </div>
                <div class="form-group">
                    <label>Name</label>
                    <input type="text" name="fullName" id="editFullName" required>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phoneNumber" id="editPhoneNumber">
                </div>
                <div class="form-group">
                    <label>Address</label>
                    <input type="text" name="address" id="editAddress">
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" id="editEmail" required>
                </div>
                <div class="form-group">
                    <button type="submit">Update</button>
                    <button type="button" class="cancel-btn" onclick="hideModal('editModal')">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h3>Confirm Deletion</h3>
            <p>Are you sure?</p>
            <button class="confirm-btn" onclick="deleteUser()">Confirm</button>
            <button class="cancel-btn" onclick="hideModal('deleteModal')">Cancel</button>
        </div>
    </div>

    <div id="successModal" class="modal">
        <div class="modal-content">
            <h3>Notification</h3>
            <p id="modalMessage"></p>
            <button class="confirm-btn" style="background-color: #4bb6b7;" onclick="hideModal('successModal')">Close</button>
        </div>
    </div>

    <script>
        let selectedId = null;

        // Show/hide sections
        document.querySelectorAll('.menu a').forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const targetId = this.getAttribute('href').substring(1);
                if (targetId === 'ManageBook') {
                    window.location.href = 'ManageBook';
                } else {
                    showSection(targetId);
                    setActiveLink(this);
                }
            });
        });

        // Search users
        function searchUser() {
            const input = document.querySelector('.search-bar').value.toLowerCase();
            document.querySelectorAll('#customer-info tbody tr').forEach(row => {
                row.style.display = row.textContent.toLowerCase().includes(input) ? '' : 'none';
            });
        }

        // Show edit modal
        function showEditModal(id, rollNumber, fullName, phoneNumber, address, email) {
            document.getElementById('editUserID').value = id;
            document.getElementById('editRollNumber').value = rollNumber || '';
            document.getElementById('editFullName').value = fullName || '';
            document.getElementById('editPhoneNumber').value = phoneNumber || '';
            document.getElementById('editAddress').value = address || '';
            document.getElementById('editEmail').value = email || '';
            showModal('editModal');
        }

        // Show delete modal
        function showDeleteModal(id) {
            selectedId = id;
            showModal('deleteModal');
        }

        // Show/hide modal
        function showModal(modalId) {
            document.getElementById(modalId).style.display = 'flex';
        }
        function hideModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        // Send request to server
        function sendRequest(data) {
            fetch('/admin', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams(data)
            })
            .then(response => response.text())
            .then(result => {
                document.getElementById('modalMessage').textContent = result.startsWith("success") ? "Action completed successfully!" : result;
                showModal('successModal');
                if (result.startsWith("success")) setTimeout(() => location.reload(), 1000);
            })
            .catch(error => {
                document.getElementById('modalMessage').textContent = "Error: " + error;
                showModal('successModal');
            });
        }

        // Add customer
        document.getElementById('addCustomerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const rollNumber = this.rollNumber.value.trim();
            const password = this.password.value.trim();
            const fullName = this.fullName.value.trim();
            const phoneNumber = this.phoneNumber.value.trim();
            const address = this.address.value.trim();
            const email = this.email.value.trim();

            let hasError = false;
            document.querySelectorAll('.error-message').forEach(span => span.style.display = 'none');

            if (!/^[A-Za-z]{2}\d{6}$/.test(rollNumber)) {
                document.getElementById('rollNumberError').textContent = "❌ Must be 2 letters + 6 digits";
                document.getElementById('rollNumberError').style.display = 'block';
                hasError = true;
            }
            if (password.length < 8) {
                document.getElementById('passwordError').textContent = "❌ At least 8 characters";
                document.getElementById('passwordError').style.display = 'block';
                hasError = true;
            }
            if (fullName.split(" ").length < 2) {
                document.getElementById('fullNameError').textContent = "❌ At least 2 words";
                document.getElementById('fullNameError').style.display = 'block';
                hasError = true;
            }
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                document.getElementById('emailError').textContent = "❌ Invalid email";
                document.getElementById('emailError').style.display = 'block';
                hasError = true;
            }

            if (!hasError) {
                sendRequest({
                    action: 'add',
                    rollNumber: rollNumber,
                    password: password,
                    fullName: fullName,
                    phoneNumber: phoneNumber,
                    address: address,
                    email: email
                });
            }
        });

        // Edit customer
        document.getElementById('editUserForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const data = {
                action: 'update',
                userID: this.userID.value,
                rollNumber: this.rollNumber.value.trim(),
                fullName: this.fullName.value.trim(),
                phoneNumber: this.phoneNumber.value.trim(),
                address: this.address.value.trim(),
                email: this.email.value.trim()
            };
            sendRequest(data);
            hideModal('editModal');
        });

        // Delete customer
        function deleteUser() {
            sendRequest({ action: 'delete', userID: selectedId });
            hideModal('deleteModal');
        }

        // Update settings
        document.getElementById('settingsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const data = {
                action: 'updateSettings',
                defaultLoanDays: this.defaultLoanDays.value,
                maxBooksAllowed: this.maxBooksAllowed.value,
                extendFee: this.extendFee.value,
                lateFeePerDay: this.lateFeePerDay.value
            };
            sendRequest(data);
        });

        // Update notification settings
        function updateNotification(rollNumber) {
            const data = {
                action: 'updateNotificationSettings',
                rollNumber: rollNumber,
                notificationInterval: document.getElementById('interval_' + rollNumber).value,
                enabled: document.getElementById('enabled_' + rollNumber).checked
            };
            sendRequest(data);
        }

        // Helper functions
        function showSection(id) {
            document.querySelectorAll('.content > div').forEach(section => section.style.display = 'none');
            document.getElementById(id).style.display = 'block';
        }

        function setActiveLink(link) {
            document.querySelectorAll('.menu a').forEach(a => a.classList.remove('active'));
            link.classList.add('active');
        }

        // Show default section
        showSection('customer-info');
    </script>
</body>
</html>