using FluentMigrator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GitTestRepo.Db.Migrations
{
    [Migration(1, "Create intial tables")]
    public class CreateInitial : Migration
    {
        public override void Down()
        {
            Execute.Sql(@"
                ALTER TABLE[dbo].[Enrollment] DROP CONSTRAINT[FK_dbo.Enrollment_dbo.Student_StudentID]
                ALTER TABLE[dbo].[Enrollment] DROP CONSTRAINT[FK_dbo.Enrollment_dbo.Course_CourseID]
                DROP TABLE[dbo].[Student]
                DROP TABLE[dbo].[Enrollment]
                DROP TABLE[dbo].[Course]"
            );
        }

        public override void Up()
        {
            if (!Schema.Table("Student").Exists() && !Schema.Table("Course").Exists() && !Schema.Table("Enrollment").Exists())
            {
                //Create.Table("Student")
                //    .WithColumn("StudentID").AsInt32().NotNullable().PrimaryKey().Identity()
                //    .WithColumn("LastName").AsString(50).Nullable()
                //    .WithColumn("FirstName").AsString(50).Nullable()
                //    .WithColumn("EnrollmentDate").AsDateTime().Nullable();

                Execute.Sql(
                    @"
                    CREATE TABLE [dbo].[Student] (
                        [StudentID]      INT           IDENTITY (1, 1) NOT NULL,
                        [LastName]       NVARCHAR (50) NULL,
                        [FirstName]      NVARCHAR (50) NULL,
                        [EnrollmentDate] DATETIME      NULL,
                        PRIMARY KEY CLUSTERED ([StudentID] ASC)
                    )

                    CREATE TABLE [dbo].[Course] (
                        [CourseID] INT           IDENTITY (1, 1) NOT NULL,
                        [Title]    NVARCHAR (50) NULL,
                        [Credits]  INT           NULL,
                        PRIMARY KEY CLUSTERED ([CourseID] ASC)
                    )

                    CREATE TABLE [dbo].[Enrollment] (
                        [EnrollmentID] INT IDENTITY (1, 1) NOT NULL,
                        [Grade]        DECIMAL(3, 2) NULL,
                        [CourseID]     INT NOT NULL,
                        [StudentID]    INT NOT NULL,
                        PRIMARY KEY CLUSTERED ([EnrollmentID] ASC),
                        CONSTRAINT [FK_dbo.Enrollment_dbo.Course_CourseID] FOREIGN KEY ([CourseID]) 
                            REFERENCES [dbo].[Course] ([CourseID]) ON DELETE CASCADE,
                        CONSTRAINT [FK_dbo.Enrollment_dbo.Student_StudentID] FOREIGN KEY ([StudentID]) 
                            REFERENCES [dbo].[Student] ([StudentID]) ON DELETE CASCADE
                    )"
                );
            }
        }
    }
}
