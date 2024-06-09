-- CreateTable
CREATE TABLE "ApplicationOauthScope" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "applicationsId" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    CONSTRAINT "ApplicationOauthScope_applicationsId_fkey" FOREIGN KEY ("applicationsId") REFERENCES "Application" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ApplicationRole" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "applicationsId" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isDefault" BOOLEAN NOT NULL,
    "isSuperRole" BOOLEAN NOT NULL,
    "updatedAt" DATETIME NOT NULL,
    "name" TEXT NOT NULL,
    CONSTRAINT "ApplicationRole_applicationsId_fkey" FOREIGN KEY ("applicationsId") REFERENCES "Application" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Application" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "accessTokenSigningKeysId" TEXT,
    "active" BOOLEAN NOT NULL,
    "data" TEXT NOT NULL,
    "idTokenSigningKeysId" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "name" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    CONSTRAINT "Application_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "GroupApplicationRole" (
    "applicationRolesId" TEXT NOT NULL,
    "groupsId" TEXT NOT NULL,
    CONSTRAINT "GroupApplicationRole_applicationRolesId_fkey" FOREIGN KEY ("applicationRolesId") REFERENCES "ApplicationRole" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "GroupApplicationRole_groupsId_fkey" FOREIGN KEY ("groupsId") REFERENCES "Group" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "GroupMember" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "groupId" TEXT NOT NULL,
    "createdAt" BIGINT NOT NULL,
    "userId" TEXT NOT NULL,
    CONSTRAINT "GroupMember_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "Group" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "GroupMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Group" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "name" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "permissions" TEXT,
    "settings" TEXT,
    CONSTRAINT "Group_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Key" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "algorithm" TEXT,
    "certificate" TEXT,
    "expiry" BIGINT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "issuer" TEXT,
    "kid" TEXT NOT NULL,
    "updatedAt" DATETIME NOT NULL,
    "name" TEXT NOT NULL,
    "privateKey" TEXT,
    "publicKey" TEXT,
    "secret" TEXT,
    "type" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "RefreshToken" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "applicationsId" TEXT,
    "expiry" BIGINT NOT NULL,
    "data" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "startInstant" BIGINT NOT NULL,
    "tenantId" TEXT,
    "token" TEXT,
    "tokenHash" TEXT,
    "tokenText" TEXT,
    "usersId" TEXT NOT NULL,
    CONSTRAINT "RefreshToken_applicationsId_fkey" FOREIGN KEY ("applicationsId") REFERENCES "Application" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "RefreshToken_usersId_fkey" FOREIGN KEY ("usersId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Tenant" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "accessTokenSigningKeysId" TEXT NOT NULL,
    "data" TEXT,
    "idTokenSigningKeysId" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "name" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "UserRegistration" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "applicationsId" TEXT NOT NULL,
    "authenticationToken" TEXT,
    "password" TEXT NOT NULL,
    "data" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastLoginInstant" BIGINT,
    "updatedAt" DATETIME NOT NULL,
    "usersId" TEXT NOT NULL,
    "verified" BOOLEAN NOT NULL,
    "verifiedInstant" BIGINT,
    CONSTRAINT "UserRegistration_applicationsId_fkey" FOREIGN KEY ("applicationsId") REFERENCES "Application" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "UserRegistration_usersId_fkey" FOREIGN KEY ("usersId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "active" BOOLEAN NOT NULL,
    "data" TEXT,
    "expiry" BIGINT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "tenantId" TEXT NOT NULL,
    "groupId" TEXT,
    CONSTRAINT "User_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "Group" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "User_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "AuthenticationKey" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "keyManager" BOOLEAN NOT NULL,
    "keyValue" TEXT NOT NULL,
    "permissions" TEXT,
    "metaData" TEXT,
    "tenantsId" TEXT,
    CONSTRAINT "AuthenticationKey_tenantsId_fkey" FOREIGN KEY ("tenantsId") REFERENCES "Tenant" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "ApplicationOauthScope_applicationsId_name_key" ON "ApplicationOauthScope"("applicationsId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "ApplicationRole_name_applicationsId_key" ON "ApplicationRole"("name", "applicationsId");

-- CreateIndex
CREATE INDEX "applications_i_1" ON "Application"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "Application_name_tenantId_key" ON "Application"("name", "tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "GroupApplicationRole_groupsId_applicationRolesId_key" ON "GroupApplicationRole"("groupsId", "applicationRolesId");

-- CreateIndex
CREATE INDEX "group_members_i_1" ON "GroupMember"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "GroupMember_groupId_userId_key" ON "GroupMember"("groupId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "Group_name_tenantId_key" ON "Group"("name", "tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "Key_kid_key" ON "Key"("kid");

-- CreateIndex
CREATE UNIQUE INDEX "Key_name_key" ON "Key"("name");

-- CreateIndex
CREATE UNIQUE INDEX "RefreshToken_token_key" ON "RefreshToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "RefreshToken_tokenHash_key" ON "RefreshToken"("tokenHash");

-- CreateIndex
CREATE INDEX "refresh_tokens_i_1" ON "RefreshToken"("startInstant");

-- CreateIndex
CREATE INDEX "refresh_tokens_i_2" ON "RefreshToken"("applicationsId");

-- CreateIndex
CREATE INDEX "refresh_tokens_i_3" ON "RefreshToken"("usersId");

-- CreateIndex
CREATE INDEX "refresh_tokens_i_4" ON "RefreshToken"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "Tenant_name_key" ON "Tenant"("name");

-- CreateIndex
CREATE INDEX "user_registrations_i_2" ON "UserRegistration"("usersId");

-- CreateIndex
CREATE UNIQUE INDEX "UserRegistration_applicationsId_usersId_key" ON "UserRegistration"("applicationsId", "usersId");

-- CreateIndex
CREATE UNIQUE INDEX "AuthenticationKey_keyValue_key" ON "AuthenticationKey"("keyValue");
