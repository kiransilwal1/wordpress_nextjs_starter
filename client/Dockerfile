# Base image with Bun
FROM oven/bun:alpine AS base
WORKDIR /app
ENV NODE_ENV=production

# Install dependencies
FROM base AS deps
COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile

# Build application
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN bun run build

# Production runner
FROM base AS runner
# Copy only necessary production files
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

EXPOSE ${PORT}
CMD ["bun", "server.js"]
