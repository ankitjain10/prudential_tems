var userDataList=[
  {
    "id": 1,
    "userName": "John Doe",
    "email": "john.doe@example.com",
    "userRole": "Admin"
  },
  {
    "id": 2,
    "userName": "Jane Smith",
    "email": "jane.smith@example.com",
    "userRole": "Manager"
  },
  {
    "id": 3,
    "userName": "Alice Johnson",
    "email": "alice.johnson@example.com",
    "userRole": "Engineer"
  }
];
var environmentApiResponse={
  "environmentCount": [
    {
      "environmentName": "Production",
      "count": 1
    },
    {
      "environmentName": "Development",
      "count": 1
    },
    {
      "environmentName": "Testing",
      "count": 1
    }
  ],
  "environmentDTOList": [
    {
      "environment": "Development",
      "type": "Mobile App",
      "projectName": "Project Beta",
      "startDate": "2025-02-01",
      "endDate": "2025-07-31",
      "status": "Completed",
      "assignedEngineer": "Jane Smith",
      "version": 0
    },
    {
      "environment": "Testing",
      "type": "API",
      "projectName": "Project Gamma",
      "startDate": "2025-03-01",
      "endDate": "2025-08-31",
      "status": "Not Started",
      "assignedEngineer": "Alice Johnson",
      "version": 0
    },
    {
      "environment": "Production",
      "type": "Web Application",
      "projectName": "Project Alpha",
      "startDate": "2025-01-01",
      "endDate": "2025-06-30",
      "status": "In-Progress",
      "assignedEngineer": "John Doe",
      "version": 0
    }
  ]
};
var bookingApiResponse={
  "environmentCount": [
    {
      "environmentName": "Production",
      "count": 5
    },
    {
      "environmentName": "Development",
      "count": 6
    },
    {
      "environmentName": "Testing",
      "count": 3
    }
  ],
  "bookingList": [
    {
      "project_name": "Project Beta",
      "start_date": "2025-03-13",
      "end_date": "2025-04-15",
      "status": "Not Started",
      "owner": "Jane Smith",
      "purpose": "Develop new features",
      "notes": "Initial phase",
      "environment_name": "Development",
      "project_id": "202513",
      "version": 1,
      "booking_id": "BID00104"
    },
    {
      "project_name": "Project Alpha",
      "start_date": "2025-03-18",
      "end_date": "2025-06-30",
      "status": "In Progress",
      "owner": "John Doe",
      "purpose": "Develop new features",
      "notes": "Initial phase",
      "environment_name": "Development",
      "project_id": "202512",
      "version": 0,
      "booking_id": "BID00101"
    },
    {
      "project_name": "Project Beta",
      "start_date": "2025-03-19",
      "end_date": "2025-07-31",
      "status": "Completed",
      "owner": "Jane Smith",
      "purpose": "Upgrade system",
      "notes": "Final phase",
      "environment_name": "Testing",
      "project_id": "202513",
      "version": 0,
      "booking_id": "BID00102"
    },
    {
      "project_name": "Project Gamma",
      "start_date": "2025-03-20",
      "end_date": "2025-08-31",
      "status": "Not Started",
      "owner": "Alice Johnson",
      "purpose": "Testing phase",
      "notes": "Planning stage",
      "environment_name": "Production",
      "project_id": "202514",
      "version": 0,
      "booking_id": "BID00103"
    },
    {
      "project_name": "Project Beta",
      "start_date": "2025-03-12",
      "end_date": "2025-04-15",
      "status": "Not Started",
      "owner": "Jane Smith",
      "purpose": "Develop new features",
      "notes": "Initial phase",
      "environment_name": "Development",
      "project_id": "202513",
      "version": 0,
      "booking_id": "BID00105"
    },
    {
      "project_name": "Project Beta",
      "start_date": "2025-03-21",
      "end_date": "2025-04-11",
      "status": "Not Started",
      "owner": "John Doe",
      "purpose": "Develop new features",
      "notes": "Initial phase",
      "environment_name": "Development",
      "project_id": "202513",
      "version": 0,
      "booking_id": "BID00106"
    },
    {
      "project_name": "Project Beta",
      "start_date": "2025-03-14",
      "end_date": "2025-04-11",
      "status": "Not Started",
      "owner": "John Doe",
      "purpose": "Develop new features",
      "notes": "Initial phase",
      "environment_name": "Development",
      "project_id": "202513",
      "version": 0,
      "booking_id": "BID00107"
    },
    {
      "project_name": "Project Beta",
      "start_date": "2025-03-14",
      "end_date": "2025-04-11",
      "status": "Not Started",
      "owner": "John Doe",
      "purpose": "Develop new features",
      "notes": "Initial phase",
      "environment_name": "Development",
      "project_id": "202513",
      "version": 0,
      "booking_id": "BID00108"
    },
    {
      "project_name": "Project Alpha",
      "start_date": "2025-03-15",
      "end_date": "2025-03-28",
      "status": "In Progress",
      "owner": "John Doe",
      "purpose": "Testing phase",
      "notes": "Planning stage",
      "environment_name": "Production",
      "project_id": "202512",
      "version": 0,
      "booking_id": "BID00109"
    },
    {
      "project_name": "Project Alpha",
      "start_date": "2025-04-12",
      "end_date": "2025-04-28",
      "status": "Not Started",
      "owner": "John Doe",
      "purpose": "Testing",
      "notes": "Planning",
      "environment_name": "Production",
      "project_id": "202512",
      "version": 0,
      "booking_id": "BID00110"
    },
    {
      "project_name": "Project Alpha",
      "start_date": "2025-04-12",
      "end_date": "2025-04-28",
      "status": "Not Started",
      "owner": "John Doe",
      "purpose": "Testing",
      "notes": "Planning",
      "environment_name": "Production",
      "project_id": "202512",
      "version": 0,
      "booking_id": "BID00111"
    },
    {
      "project_name": "Project Alpha",
      "start_date": "2025-04-12",
      "end_date": "2025-04-28",
      "status": "Not Started",
      "owner": "John Doe",
      "purpose": "Testing",
      "notes": "Planning",
      "environment_name": "Production",
      "project_id": "202512",
      "version": 0,
      "booking_id": "BID00112"
    },
    {
      "project_name": "Project Gamma",
      "start_date": "2025-04-12",
      "end_date": "2025-04-28",
      "status": "Not Started",
      "owner": "Alice Johnson",
      "purpose": "UAT Testing",
      "notes": "Planning",
      "environment_name": "Testing",
      "project_id": "202514",
      "version": 0,
      "booking_id": "BID00113"
    },
    {
      "project_name": "Project Gamma",
      "start_date": "2025-04-12",
      "end_date": "2025-04-28",
      "status": "Not Started",
      "owner": "Alice Johnson",
      "purpose": "UAT Testing",
      "notes": "Planning",
      "environment_name": "Testing",
      "project_id": "202514",
      "version": 0,
      "booking_id": "BID00114"
    }
  ]
};