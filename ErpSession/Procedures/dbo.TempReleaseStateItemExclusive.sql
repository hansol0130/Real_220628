USE [ErpSession]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

        CREATE PROCEDURE [dbo].[TempReleaseStateItemExclusive]
            @id         tSessionId,
            @lockCookie int
        AS
            UPDATE [ErpSession].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, GETUTCDATE()), 
                Locked = 0
            WHERE SessionId = @id AND LockCookie = @lockCookie

            RETURN 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
GO