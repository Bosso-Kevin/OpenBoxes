# OpenBoxes Docker for Dokploy

Deploy [OpenBoxes](https://openboxes.com) supply chain management system on Dokploy.

## Quick Start

### Option 1: Deploy via Dokploy Docker Compose

1. In Dokploy, create a new **Docker Compose** project
2. Point to this repository or upload these files
3. Configure environment variables (see below)
4. Deploy!

### Option 2: Local Testing

```bash
# Clone and start
cd openboxes-docker
cp .env.example .env
# Edit .env with your settings
docker compose up --build
```

Access at: `http://localhost:8080/openboxes`

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `OPENBOXES_VERSION` | v0.9.6-hotfix1 | OpenBoxes release version |
| `MYSQL_ROOT_PASSWORD` | openboxes_root | MySQL root password |
| `MYSQL_DATABASE` | openboxes | Database name |
| `MYSQL_USER` | openboxes | Database user |
| `MYSQL_PASSWORD` | openboxes | Database password |
| `OPENBOXES_URL` | http://localhost:8080 | Public URL (important for production) |
| `MAIL_ENABLED` | false | Enable email notifications |

## Dokploy Configuration

1. **Create Docker Compose Service** in Dokploy
2. **Set Environment Variables**:
   - Change all passwords from defaults
   - Set `OPENBOXES_URL` to your domain (e.g., `https://openboxes.yourdomain.com`)
3. **Configure Domain/SSL** in Dokploy settings
4. **Deploy** and wait ~3-5 minutes for initial startup

## First Login

After deployment, navigate to your URL. OpenBoxes will:
1. Initialize the database (first run takes longer)
2. Present a setup wizard
3. Create your admin account

## Requirements

- **RAM**: Minimum 2GB (4GB recommended)
- **Storage**: 10GB+ for database and uploads
- **Ports**: 8080 (app), 3306 (MySQL - internal only)

## Files

```
├── Dockerfile              # Builds OpenBoxes Tomcat image
├── docker-compose.yml      # Service definitions
├── openboxes-config.properties  # Application config
├── mysql.cnf               # MySQL optimization
├── init-db.sh              # Database initialization
└── .env.example            # Environment template
```

## Troubleshooting

**Container keeps restarting?**
- Check logs: `docker compose logs openboxes`
- Ensure MySQL is healthy first: `docker compose logs db`

**Application not loading?**
- Initial startup takes 2-3 minutes
- Verify health: `docker compose ps`

**Database connection errors?**
- Confirm MySQL is ready before OpenBoxes starts
- Check credentials match in `.env` and `openboxes-config.properties`
