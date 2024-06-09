-- Создание ролей
INSERT INTO Roles (role_name) VALUES ('user'), ('admin');

-- Присвоение роли пользователю
INSERT INTO UserRoles (user_id, role_id) VALUES (1, (SELECT role_id FROM Roles WHERE role_name = 'admin'));
INSERT INTO UserRoles (user_id, role_id) VALUES (2, (SELECT role_id FROM Roles WHERE role_name = 'user'));
