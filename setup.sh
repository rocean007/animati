#!/bin/bash

# =============================================================================
# BRAINROT CONTENT AUTOMATION - MASTER SETUP SCRIPT
# Creates the full Next.js project structure ready for Vercel deployment
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_NAME="brainrot-automation"

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║        BRAINROT CONTENT AUTOMATION - SETUP SCRIPT           ║"
echo "║     Automated YouTube Uploads | Free AI | Vercel Ready      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${BLUE}[1/8] Creating project directory...${NC}"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Create directory structure
mkdir -p pages/api/cron
mkdir -p pages/api
mkdir -p components
mkdir -p lib
mkdir -p public
mkdir -p data

echo -e "${GREEN}✓ Directory structure created${NC}"

# =============================================================================
# package.json
# =============================================================================
echo -e "${BLUE}[2/8] Creating package.json...${NC}"
cat > package.json << 'PACKAGE_EOF'
{
  "name": "brainrot-automation",
  "version": "1.0.0",
  "description": "Automated brainrot content generator for YouTube",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "14.2.5",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "mongoose": "^8.5.1",
    "axios": "^1.7.2",
    "fluent-ffmpeg": "^2.1.3",
    "googleapis": "^140.0.1",
    "node-cron": "^3.0.3",
    "form-data": "^4.0.0",
    "sharp": "^0.33.4",
    "uuid": "^10.0.0",
    "date-fns": "^3.6.0"
  },
  "devDependencies": {
    "eslint": "^8.57.0",
    "eslint-config-next": "14.2.5"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
PACKAGE_EOF
echo -e "${GREEN}✓ package.json created${NC}"

# =============================================================================
# vercel.json
# =============================================================================
echo -e "${BLUE}[3/8] Creating vercel.json...${NC}"
cat > vercel.json << 'VERCEL_EOF'
{
  "version": 2,
  "framework": "nextjs",
  "buildCommand": "next build",
  "devCommand": "next dev",
  "installCommand": "npm install",
  "functions": {
    "pages/api/cron/generate-videos.js": {
      "maxDuration": 300
    },
    "pages/api/*.js": {
      "maxDuration": 60
    }
  },
  "crons": [
    {
      "path": "/api/cron/generate-videos",
      "schedule": "0 14 * * *"
    },
    {
      "path": "/api/cron/generate-videos",
      "schedule": "0 19 * * *"
    },
    {
      "path": "/api/cron/generate-videos",
      "schedule": "0 11 * * *"
    },
    {
      "path": "/api/cron/generate-videos",
      "schedule": "0 9 * * *"
    },
    {
      "path": "/api/cron/generate-videos",
      "schedule": "0 22 * * *"
    }
  ],
  "headers": [
    {
      "source": "/api/(.*)",
      "headers": [
        {
          "key": "Access-Control-Allow-Origin",
          "value": "*"
        },
        {
          "key": "Access-Control-Allow-Methods",
          "value": "GET, POST, PUT, DELETE, OPTIONS"
        },
        {
          "key": "Access-Control-Allow-Headers",
          "value": "Content-Type, Authorization"
        }
      ]
    }
  ],
  "env": {
    "MONGODB_URI": "@mongodb_uri",
    "YOUTUBE_CLIENT_ID": "@youtube_client_id",
    "YOUTUBE_CLIENT_SECRET": "@youtube_client_secret",
    "YOUTUBE_REFRESH_TOKEN": "@youtube_refresh_token",
    "HUGGINGFACE_API_KEY": "@huggingface_api_key",
    "ELEVENLABS_API_KEY": "@elevenlabs_api_key",
    "CRON_SECRET": "@cron_secret"
  }
}
VERCEL_EOF
echo -e "${GREEN}✓ vercel.json created (5 optimal upload times configured)${NC}"

# =============================================================================
# next.config.js
# =============================================================================
cat > next.config.js << 'NEXT_EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  serverExternalPackages: ['mongoose', 'fluent-ffmpeg', 'sharp'],
  images: {
    domains: ['huggingface.co', 'api-inference.huggingface.co'],
  },
  async headers() {
    return [
      {
        source: '/api/:path*',
        headers: [
          { key: 'Access-Control-Allow-Origin', value: '*' },
          { key: 'Access-Control-Allow-Methods', value: 'GET,POST,PUT,DELETE,OPTIONS' },
          { key: 'Access-Control-Allow-Headers', value: 'Content-Type, Authorization' },
        ],
      },
    ];
  },
};

module.exports = nextConfig;
NEXT_EOF

# =============================================================================
# .env.example
# =============================================================================
cat > .env.example << 'ENV_EOF'
# MongoDB Atlas (Free M0 cluster)
# Get at: https://mongodb.com/cloud/atlas
MONGODB_URI=mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/brainrot?retryWrites=true&w=majority

# YouTube API Credentials
# Get at: https://console.cloud.google.com → Enable YouTube Data API v3
YOUTUBE_CLIENT_ID=your_client_id_here.apps.googleusercontent.com
YOUTUBE_CLIENT_SECRET=GOCSPX-your_secret_here
YOUTUBE_REFRESH_TOKEN=your_refresh_token_here

# HuggingFace API (FREE - Image Generation)
# Get at: https://huggingface.co/settings/tokens
HUGGINGFACE_API_KEY=hf_your_key_here

# ElevenLabs TTS (FREE 10k chars/month)
# Get at: https://elevenlabs.io
ELEVENLABS_API_KEY=your_elevenlabs_key_here

# Cron Security Secret (generate with: openssl rand -hex 32)
CRON_SECRET=your_random_secret_here

# Optional: OpenRouter (FREE tier - backup LLM)
# Get at: https://openrouter.ai
OPENROUTER_API_KEY=sk-or-your_key_here
ENV_EOF

cp .env.example .env.local

# =============================================================================
# .gitignore
# =============================================================================
cat > .gitignore << 'GIT_EOF'
# Dependencies
node_modules/
.pnp
.pnp.js

# Environment variables - NEVER commit these
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Next.js
.next/
out/

# Build outputs
dist/
build/

# Vercel
.vercel

# Logs
*.log
npm-debug.log*

# OS
.DS_Store
Thumbs.db

# Generated videos (too large for git)
/tmp/
/videos/
*.mp4
*.wav
*.mp3

# Database
*.sqlite
GIT_EOF

# =============================================================================
# lib/mongodb.js
# =============================================================================
echo -e "${BLUE}[4/8] Creating library files...${NC}"
cat > lib/mongodb.js << 'MONGO_EOF'
import mongoose from 'mongoose';

const MONGODB_URI = process.env.MONGODB_URI;

if (!MONGODB_URI) {
  throw new Error('Please define the MONGODB_URI environment variable inside .env.local');
}

let cached = global.mongoose;

if (!cached) {
  cached = global.mongoose = { conn: null, promise: null };
}

async function dbConnect() {
  if (cached.conn) {
    return cached.conn;
  }

  if (!cached.promise) {
    const opts = {
      bufferCommands: false,
    };

    cached.promise = mongoose.connect(MONGODB_URI, opts).then((mongoose) => {
      return mongoose;
    });
  }

  try {
    cached.conn = await cached.promise;
  } catch (e) {
    cached.promise = null;
    throw e;
  }

  return cached.conn;
}

export default dbConnect;
MONGO_EOF

# =============================================================================
# lib/models.js
# =============================================================================
cat > lib/models.js << 'MODELS_EOF'
import mongoose from 'mongoose';

// Job Schema - tracks each video generation attempt
const JobSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  type: { type: String, enum: ['storytelling', 'dance', 'top5'], required: true },
  status: { type: String, enum: ['pending', 'processing', 'completed', 'failed'], default: 'pending' },
  character: { type: String, default: '' },
  title: { type: String, default: '' },
  description: { type: String, default: '' },
  youtubeUrl: { type: String, default: '' },
  youtubeId: { type: String, default: '' },
  error: { type: String, default: '' },
  scheduledFor: { type: Date, default: null },
  completedAt: { type: Date, default: null },
  createdAt: { type: Date, default: Date.now },
});

// Config Schema - stores dashboard settings
const ConfigSchema = new mongoose.Schema({
  key: { type: String, required: true, unique: true },
  value: { type: mongoose.Schema.Types.Mixed, required: true },
  updatedAt: { type: Date, default: Date.now },
});

// Analytics Schema - daily stats
const AnalyticsSchema = new mongoose.Schema({
  date: { type: String, required: true, unique: true },
  videosGenerated: { type: Number, default: 0 },
  videosUploaded: { type: Number, default: 0 },
  failures: { type: Number, default: 0 },
  totalViews: { type: Number, default: 0 },
});

export const Job = mongoose.models.Job || mongoose.model('Job', JobSchema);
export const Config = mongoose.models.Config || mongoose.model('Config', ConfigSchema);
export const Analytics = mongoose.models.Analytics || mongoose.model('Analytics', AnalyticsSchema);
MODELS_EOF

# =============================================================================
# lib/aiServices.js
# =============================================================================
cat > lib/aiServices.js << 'AI_EOF'
// Free AI Services Handler
// Uses: HuggingFace (images), ElevenLabs (voice), OpenRouter (text)

export async function generateImage(prompt) {
  const models = [
    'stabilityai/stable-diffusion-xl-base-1.0',
    'runwayml/stable-diffusion-v1-5',
    'CompVis/stable-diffusion-v1-4',
  ];

  for (const model of models) {
    try {
      const response = await fetch(
        `https://api-inference.huggingface.co/models/${model}`,
        {
          method: 'POST',
          headers: {
            Authorization: `Bearer ${process.env.HUGGINGFACE_API_KEY}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            inputs: prompt,
            parameters: {
              width: 1080,
              height: 1920,
              num_inference_steps: 20,
            },
          }),
        }
      );

      if (response.ok) {
        const buffer = await response.arrayBuffer();
        return Buffer.from(buffer);
      }

      // If model is loading, wait and retry
      if (response.status === 503) {
        await new Promise(r => setTimeout(r, 10000));
        continue;
      }
    } catch (err) {
      console.error(`HuggingFace model ${model} failed:`, err.message);
    }
  }

  throw new Error('All image generation models failed');
}

export async function generateVoice(text, voiceId = 'Rachel') {
  // ElevenLabs free tier: 10k chars/month
  try {
    const voices = {
      Rachel: '21m00Tcm4TlvDq8ikWAM',
      Domi: 'AZnzlk1XvdvUeBnXmlld',
      Bella: 'EXAVITQu4vr4xnSDxMaL',
      Antoni: 'ErXwobaYiN019PkySvjV',
      Elli: 'MF3mGyEYCl7XYWbV9V6O',
    };

    const selectedVoice = voices[voiceId] || voices.Rachel;

    const response = await fetch(
      `https://api.elevenlabs.io/v1/text-to-speech/${selectedVoice}`,
      {
        method: 'POST',
        headers: {
          'xi-api-key': process.env.ELEVENLABS_API_KEY,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          text: text.substring(0, 2500), // Stay within free tier
          model_id: 'eleven_monolingual_v1',
          voice_settings: {
            stability: 0.5,
            similarity_boost: 0.75,
          },
        }),
      }
    );

    if (!response.ok) {
      throw new Error(`ElevenLabs error: ${response.status}`);
    }

    const buffer = await response.arrayBuffer();
    return Buffer.from(buffer);
  } catch (err) {
    console.error('ElevenLabs failed, using fallback TTS:', err.message);
    return await generateVoiceFallback(text);
  }
}

// Free fallback: StreamElements TTS (completely free, no key needed)
async function generateVoiceFallback(text) {
  const encoded = encodeURIComponent(text.substring(0, 500));
  const voice = 'Brian'; // or: Amy, Emma, Brian, Russell, Nicole
  const url = `https://api.streamelements.com/kappa/v2/speech?voice=${voice}&text=${encoded}`;

  const response = await fetch(url);
  if (!response.ok) throw new Error('StreamElements TTS failed');

  const buffer = await response.arrayBuffer();
  return Buffer.from(buffer);
}

export async function generateScript(contentType, character, topic) {
  // Uses OpenRouter free tier (mistral-7b is free)
  const prompts = {
    storytelling: `Write a 150-word exciting story about ${character} from brainrot memes. Make it dramatic and funny. Include: a problem, adventure, and resolution. No hashtags.`,
    dance: `Write a 100-word energetic description of ${character} doing an epic dance battle. Include wild dance moves and brainrot energy. Make it hype and funny.`,
    top5: `Write a TOP 5 list about "${topic}" featuring brainrot characters like ${character}. Format: "Number 5: [item]" etc. Keep each item 1-2 sentences. Total 150 words.`,
  };

  try {
    const response = await fetch('https://openrouter.ai/api/v1/chat/completions', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${process.env.OPENROUTER_API_KEY}`,
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://brainrot-automation.vercel.app',
      },
      body: JSON.stringify({
        model: 'mistralai/mistral-7b-instruct:free',
        messages: [{ role: 'user', content: prompts[contentType] || prompts.storytelling }],
        max_tokens: 300,
      }),
    });

    if (response.ok) {
      const data = await response.json();
      return data.choices[0].message.content;
    }
  } catch (err) {
    console.error('OpenRouter failed:', err.message);
  }

  // Fallback: hardcoded scripts if AI fails
  return getFallbackScript(contentType, character);
}

function getFallbackScript(type, character) {
  const scripts = {
    storytelling: `${character} was chilling in Ohio when suddenly everything went CRAZY! The skibidi toilet appeared and chaos erupted. ${character} had to use their ultimate brainrot powers to save the day. After an EPIC battle, ${character} emerged victorious! The whole sigma squad celebrated. This was truly the most Ohio moment ever recorded in human history. GG no re!`,
    dance: `${character} enters the dance floor and the crowd goes WILD! They bust out the griddy, then switch to the rizz dance. The skibidi moves are UNMATCHED. ${character} hits the woah and everyone loses their mind. Pure sigma energy radiating from every move. This is the most fire dance battle in brainrot history!`,
    top5: `Number 5: ${character} eating gyatt for breakfast. Number 4: ${character} going full sigma in Ohio. Number 3: ${character} defeating the skibidi toilet army. Number 2: ${character} achieving maximum rizz levels. Number 1: ${character} becoming the ultimate brainrot champion of the universe!`,
  };
  return scripts[type] || scripts.storytelling;
}
AI_EOF

# =============================================================================
# lib/youtubeUploader.js
# =============================================================================
cat > lib/youtubeUploader.js << 'YT_EOF'
import { google } from 'googleapis';
import fs from 'fs';

export async function uploadToYouTube(videoPath, title, description, tags) {
  const oauth2Client = new google.auth.OAuth2(
    process.env.YOUTUBE_CLIENT_ID,
    process.env.YOUTUBE_CLIENT_SECRET,
    'https://developers.google.com/oauthplayground'
  );

  oauth2Client.setCredentials({
    refresh_token: process.env.YOUTUBE_REFRESH_TOKEN,
  });

  const youtube = google.youtube({ version: 'v3', auth: oauth2Client });

  const allTags = [
    ...tags,
    'brainrot', 'skibidi', 'sigma', 'ohio', 'rizz', 'gyatt',
    'viral', 'meme', 'funny', 'shorts', 'trending',
  ].slice(0, 30);

  const response = await youtube.videos.insert({
    part: ['snippet', 'status'],
    requestBody: {
      snippet: {
        title: title.substring(0, 100),
        description: `${description}\n\n#brainrot #shorts #viral #sigma #ohio #skibidi\n\nThis video was auto-generated. Subscribe for daily brainrot content!`,
        tags: allTags,
        categoryId: '23', // Comedy
        defaultLanguage: 'en',
        defaultAudioLanguage: 'en',
      },
      status: {
        privacyStatus: 'public',
        selfDeclaredMadeForKids: false,
      },
    },
    media: {
      mimeType: 'video/mp4',
      body: fs.createReadStream(videoPath),
    },
  });

  return {
    id: response.data.id,
    url: `https://www.youtube.com/watch?v=${response.data.id}`,
  };
}

// Get optimal upload time based on day of week
export function getOptimalUploadTime() {
  const now = new Date();
  const day = now.getDay(); // 0=Sunday, 6=Saturday

  // Research-based optimal times (EST/UTC-5)
  // Best days: Thursday, Friday, Saturday, Sunday
  // Best times: 2-4 PM EST = 19:00-21:00 UTC
  const schedule = {
    0: ['14:00', '19:00'], // Sunday
    1: ['12:00', '17:00'], // Monday
    2: ['12:00', '17:00'], // Tuesday
    3: ['12:00', '17:00'], // Wednesday
    4: ['14:00', '19:00'], // Thursday (best day)
    5: ['14:00', '19:00'], // Friday (best day)
    6: ['11:00', '16:00'], // Saturday
  };

  return schedule[day];
}
YT_EOF

# =============================================================================
# lib/videoCreator.js
# =============================================================================
cat > lib/videoCreator.js << 'VIDEO_EOF'
import { exec } from 'child_process';
import { promisify } from 'util';
import fs from 'fs';
import path from 'path';
import os from 'os';

const execAsync = promisify(exec);

export async function createVideo(images, audioBuffer, outputPath) {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'brainrot-'));

  try {
    // Save images
    const imagePaths = [];
    for (let i = 0; i < images.length; i++) {
      const imgPath = path.join(tmpDir, `frame_${i.toString().padStart(3, '0')}.jpg`);
      fs.writeFileSync(imgPath, images[i]);
      imagePaths.push(imgPath);
    }

    // Save audio
    const audioPath = path.join(tmpDir, 'narration.mp3');
    fs.writeFileSync(audioPath, audioBuffer);

    // Create image list for FFmpeg
    const listPath = path.join(tmpDir, 'images.txt');
    const listContent = imagePaths.map(p => `file '${p}'\nduration 3`).join('\n');
    fs.writeFileSync(listPath, listContent);

    // FFmpeg command - creates video from images + audio
    // Using 9:16 aspect ratio (1080x1920) for YouTube Shorts
    const cmd = `ffmpeg -y \
      -f concat -safe 0 -i "${listPath}" \
      -i "${audioPath}" \
      -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,fps=30" \
      -c:v libx264 -preset ultrafast -crf 23 \
      -c:a aac -b:a 128k \
      -shortest \
      -movflags +faststart \
      "${outputPath}"`;

    await execAsync(cmd);

    return outputPath;
  } finally {
    // Cleanup temp files
    try {
      fs.rmSync(tmpDir, { recursive: true, force: true });
    } catch (e) {}
  }
}

export function isFFmpegAvailable() {
  return new Promise((resolve) => {
    exec('ffmpeg -version', (err) => resolve(!err));
  });
}
VIDEO_EOF

# =============================================================================
# pages/api/cron/generate-videos.js  (THE MAIN AUTOMATION ENGINE)
# =============================================================================
echo -e "${BLUE}[5/8] Creating API routes...${NC}"
cat > pages/api/cron/generate-videos.js << 'CRON_EOF'
import dbConnect from '../../../lib/mongodb';
import { Job, Config, Analytics } from '../../../lib/models';
import { generateImage, generateVoice, generateScript } from '../../../lib/aiServices';
import { createVideo } from '../../../lib/videoCreator';
import { uploadToYouTube } from '../../../lib/youtubeUploader';
import { v4 as uuidv4 } from 'uuid';
import path from 'path';
import os from 'os';
import fs from 'fs';

// Brainrot characters dataset
const CHARACTERS = [
  { name: 'Skibidi Toilet', style: 'toilet head, waving, bathroom chaos' },
  { name: 'Sigma Cat', style: 'cool cat, sunglasses, sigma face, anime style' },
  { name: 'Baby Gronk', style: 'young football player, rizz pose, stadium' },
  { name: 'Fanum', style: 'streamer character, gaming setup, hoodie' },
  { name: 'Kai Cenat', style: 'energetic streamer, streaming chair, hype pose' },
  { name: 'Based Gigachad', style: 'ultra chad face, muscular, confident pose' },
  { name: 'NPC Girl', style: 'anime NPC character, pink hair, repetitive gestures' },
  { name: 'Rizz God', style: 'charismatic character, smooth pose, glowing aura' },
];

const TOP5_TOPICS = [
  'Most Brainrot Moments in History',
  'Sigma Moves That Hit Different',
  'Ohio Events That Should Not Exist',
  'Ultimate Rizz Techniques',
  'Peak Skibidi Moments',
  'Most Gyatt Moments Ever',
  'Bussin Brainrot Clips',
  'No Cap Best Memes of the Year',
];

export default async function handler(req, res) {
  // Security: verify this is called by Vercel cron or authenticated user
  const authHeader = req.headers.authorization;
  const cronSecret = process.env.CRON_SECRET;

  if (cronSecret && authHeader !== `Bearer ${cronSecret}`) {
    // Allow Vercel's internal cron calls (they don't send auth header the same way)
    const isCronCall = req.headers['x-vercel-cron'] === '1';
    if (!isCronCall) {
      return res.status(401).json({ error: 'Unauthorized' });
    }
  }

  if (req.method !== 'GET' && req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    await dbConnect();

    // Get config
    const configDocs = await Config.find({});
    const config = {};
    configDocs.forEach(doc => { config[doc.key] = doc.value; });

    const videosPerDay = config.videosPerDay || 5;
    const contentTypes = config.contentTypes || ['storytelling', 'dance', 'top5'];
    const uploadEnabled = config.uploadEnabled !== false;

    // Check how many videos were already generated today
    const today = new Date().toISOString().split('T')[0];
    const todayStart = new Date(today);
    const todayEnd = new Date(todayStart.getTime() + 86400000);

    const todayJobs = await Job.countDocuments({
      status: 'completed',
      completedAt: { $gte: todayStart, $lt: todayEnd },
    });

    if (todayJobs >= videosPerDay) {
      return res.status(200).json({
        message: `Daily limit reached: ${todayJobs}/${videosPerDay} videos already generated today`,
        todayCount: todayJobs,
      });
    }

    // Pick random character and content type
    const character = CHARACTERS[Math.floor(Math.random() * CHARACTERS.length)];
    const contentType = contentTypes[Math.floor(Math.random() * contentTypes.length)];
    const topic = TOP5_TOPICS[Math.floor(Math.random() * TOP5_TOPICS.length)];

    // Create job record
    const jobId = uuidv4();
    const job = new Job({
      id: jobId,
      type: contentType,
      status: 'processing',
      character: character.name,
      createdAt: new Date(),
    });
    await job.save();

    console.log(`[CRON] Starting job ${jobId}: ${contentType} with ${character.name}`);

    try {
      // STEP 1: Generate script
      console.log('[CRON] Step 1: Generating script...');
      const script = await generateScript(contentType, character.name, topic);

      // STEP 2: Generate images
      console.log('[CRON] Step 2: Generating images...');
      const imagePrompts = generateImagePrompts(contentType, character, script);
      const imageBuffers = [];

      for (const prompt of imagePrompts) {
        try {
          const img = await generateImage(prompt);
          imageBuffers.push(img);
          await new Promise(r => setTimeout(r, 2000)); // Rate limit
        } catch (err) {
          console.error('Image generation error:', err.message);
          // Continue with fewer images if some fail
        }
      }

      if (imageBuffers.length === 0) {
        throw new Error('No images could be generated');
      }

      // STEP 3: Generate voice
      console.log('[CRON] Step 3: Generating voice...');
      const audioBuffer = await generateVoice(script);

      // STEP 4: Create video
      console.log('[CRON] Step 4: Creating video...');
      const videoPath = path.join(os.tmpdir(), `${jobId}.mp4`);
      await createVideo(imageBuffers, audioBuffer, videoPath);

      // STEP 5: Generate title & description
      const title = generateTitle(contentType, character.name, topic);
      const description = generateDescription(contentType, character.name, script);
      const tags = generateTags(contentType, character.name);

      // STEP 6: Upload to YouTube
      let youtubeId = '';
      let youtubeUrl = '';

      if (uploadEnabled) {
        console.log('[CRON] Step 5: Uploading to YouTube...');
        const uploadResult = await uploadToYouTube(videoPath, title, description, tags);
        youtubeId = uploadResult.id;
        youtubeUrl = uploadResult.url;
        console.log(`[CRON] Uploaded: ${youtubeUrl}`);
      }

      // Cleanup video file
      try { fs.unlinkSync(videoPath); } catch (e) {}

      // Update job as completed
      await Job.updateOne(
        { id: jobId },
        {
          status: 'completed',
          title,
          description,
          youtubeId,
          youtubeUrl,
          completedAt: new Date(),
        }
      );

      // Update analytics
      await Analytics.findOneAndUpdate(
        { date: today },
        {
          $inc: {
            videosGenerated: 1,
            videosUploaded: uploadEnabled ? 1 : 0,
          },
        },
        { upsert: true }
      );

      console.log(`[CRON] Job ${jobId} completed successfully!`);

      return res.status(200).json({
        success: true,
        jobId,
        title,
        youtubeUrl,
        character: character.name,
        type: contentType,
      });

    } catch (err) {
      console.error(`[CRON] Job ${jobId} failed:`, err.message);

      await Job.updateOne(
        { id: jobId },
        {
          status: 'failed',
          error: err.message,
          completedAt: new Date(),
        }
      );

      // Update failure analytics
      await Analytics.findOneAndUpdate(
        { date: today },
        { $inc: { failures: 1 } },
        { upsert: true }
      );

      throw err;
    }

  } catch (err) {
    console.error('[CRON] Handler error:', err);
    return res.status(500).json({ error: err.message });
  }
}

function generateImagePrompts(contentType, character, script) {
  const base = `${character.name}, ${character.style}, vibrant colors, digital art, cartoon style, high quality`;

  const prompts = {
    storytelling: [
      `${base}, beginning of story, establishing shot`,
      `${base}, exciting action scene, dynamic pose`,
      `${base}, climax moment, dramatic lighting`,
      `${base}, victory celebration, confetti`,
      `${base}, conclusion scene, happy ending`,
    ],
    dance: [
      `${base}, dance battle arena, crowd watching`,
      `${base}, epic dance move, motion blur`,
      `${base}, neon lights, dance floor`,
      `${base}, victory dance pose, spotlight`,
    ],
    top5: [
      `${base}, number 5 ranking, scoreboard`,
      `${base}, number 3 highlight, action`,
      `${base}, number 1 champion, trophy, celebration`,
    ],
  };

  return prompts[contentType] || prompts.storytelling;
}

function generateTitle(contentType, characterName, topic) {
  const titles = {
    storytelling: [
      `${characterName}'s INSANE Adventure Goes WRONG 😱 #shorts`,
      `${characterName} VS The World (BRAINROT STORY) 💀`,
      `${characterName} Has The Most OHIO Moment Ever 🤣 #brainrot`,
    ],
    dance: [
      `${characterName} Dance Battle Goes CRAZY 🔥 #shorts`,
      `${characterName} Has ULTIMATE Rizz On The Dance Floor 💃`,
      `${characterName} Sigma Dance That BROKE The Internet 😤`,
    ],
    top5: [
      `Top 5 ${topic} ft. ${characterName} 🔥 #brainrot`,
      `TOP 5 MOST OHIO ${topic} RANKED 💀 #shorts`,
      `Ranking The MOST GYATT ${topic} (No Cap) 🗣️`,
    ],
  };

  const options = titles[contentType] || titles.storytelling;
  return options[Math.floor(Math.random() * options.length)];
}

function generateDescription(contentType, characterName, script) {
  return `${script}\n\nFeaturing: ${characterName} in the most brainrot content on the internet!\n\nWatch daily brainrot videos - Subscribe NOW! 🔔\n\n#brainrot #${characterName.replace(/\s/g, '')} #shorts #viral #sigma #ohio #skibidi #rizz #gyatt #meme`;
}

function generateTags(contentType, characterName) {
  return [
    characterName.toLowerCase().replace(/\s/g, ''),
    contentType,
    'brainrot',
    'skibidi',
    'ohio',
    'sigma',
    'rizz',
    'gyatt',
    'shorts',
    'viral',
    'meme',
    'funny',
    'animated',
  ];
}
CRON_EOF

# =============================================================================
# pages/api/config.js
# =============================================================================
cat > pages/api/config.js << 'CONFIG_EOF'
import dbConnect from '../../lib/mongodb';
import { Config } from '../../lib/models';

export default async function handler(req, res) {
  await dbConnect();

  if (req.method === 'GET') {
    const configs = await Config.find({});
    const result = {};
    configs.forEach(c => { result[c.key] = c.value; });
    return res.status(200).json(result);
  }

  if (req.method === 'POST') {
    const updates = req.body;
    for (const [key, value] of Object.entries(updates)) {
      await Config.findOneAndUpdate(
        { key },
        { key, value, updatedAt: new Date() },
        { upsert: true }
      );
    }
    return res.status(200).json({ success: true });
  }

  res.status(405).json({ error: 'Method not allowed' });
}
CONFIG_EOF

# =============================================================================
# pages/api/jobs.js
# =============================================================================
cat > pages/api/jobs.js << 'JOBS_EOF'
import dbConnect from '../../lib/mongodb';
import { Job, Analytics } from '../../lib/models';

export default async function handler(req, res) {
  await dbConnect();

  if (req.method === 'GET') {
    const { limit = 20, page = 1 } = req.query;
    const skip = (parseInt(page) - 1) * parseInt(limit);

    const [jobs, total, analytics] = await Promise.all([
      Job.find({}).sort({ createdAt: -1 }).limit(parseInt(limit)).skip(skip),
      Job.countDocuments({}),
      Analytics.find({}).sort({ date: -1 }).limit(7),
    ]);

    const today = new Date().toISOString().split('T')[0];
    const todayAnalytics = analytics.find(a => a.date === today) || {
      videosGenerated: 0,
      videosUploaded: 0,
      failures: 0,
    };

    // Calculate success rate
    const totalCompleted = await Job.countDocuments({ status: 'completed' });
    const totalJobs = await Job.countDocuments({});
    const successRate = totalJobs > 0 ? Math.round((totalCompleted / totalJobs) * 100) : 0;

    return res.status(200).json({
      jobs,
      total,
      page: parseInt(page),
      totalPages: Math.ceil(total / parseInt(limit)),
      todayStats: todayAnalytics,
      successRate,
      analytics,
    });
  }

  if (req.method === 'DELETE') {
    const { id } = req.query;
    if (id) {
      await Job.deleteOne({ id });
    } else {
      await Job.deleteMany({});
    }
    return res.status(200).json({ success: true });
  }

  res.status(405).json({ error: 'Method not allowed' });
}
JOBS_EOF

# =============================================================================
# pages/api/trigger.js  - Manual trigger from dashboard
# =============================================================================
cat > pages/api/trigger.js << 'TRIGGER_EOF'
export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    // Call the cron endpoint directly
    const baseUrl = process.env.VERCEL_URL
      ? `https://${process.env.VERCEL_URL}`
      : 'http://localhost:3000';

    const response = await fetch(`${baseUrl}/api/cron/generate-videos`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${process.env.CRON_SECRET}`,
      },
    });

    const data = await response.json();
    return res.status(response.status).json(data);
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
}
TRIGGER_EOF

# =============================================================================
# pages/api/stats.js
# =============================================================================
cat > pages/api/stats.js << 'STATS_EOF'
import dbConnect from '../../lib/mongodb';
import { Job, Analytics } from '../../lib/models';

export default async function handler(req, res) {
  await dbConnect();

  const today = new Date().toISOString().split('T')[0];
  const todayStart = new Date(today);
  const todayEnd = new Date(todayStart.getTime() + 86400000);

  const [todayCompleted, totalCompleted, totalJobs, recentJob] = await Promise.all([
    Job.countDocuments({ status: 'completed', completedAt: { $gte: todayStart, $lt: todayEnd } }),
    Job.countDocuments({ status: 'completed' }),
    Job.countDocuments({}),
    Job.findOne({ status: 'completed' }).sort({ completedAt: -1 }),
  ]);

  const successRate = totalJobs > 0 ? Math.round((totalCompleted / totalJobs) * 100) : 0;

  return res.status(200).json({
    todayVideos: todayCompleted,
    totalVideos: totalCompleted,
    successRate,
    lastUpload: recentJob?.completedAt || null,
    lastVideoUrl: recentJob?.youtubeUrl || null,
  });
}
STATS_EOF

# =============================================================================
# components/Dashboard.jsx  (MAIN UI)
# =============================================================================
echo -e "${BLUE}[6/8] Creating React components...${NC}"
cat > components/Dashboard.jsx << 'DASHBOARD_EOF'
import { useState, useEffect, useCallback } from 'react';

const OPTIMAL_TIMES = [
  { label: '9:00 AM UTC (Best for Asia)', value: '09:00' },
  { label: '11:00 AM UTC (Morning peak)', value: '11:00' },
  { label: '2:00 PM UTC (Afternoon peak)', value: '14:00' },
  { label: '7:00 PM UTC (Evening peak ★)', value: '19:00' },
  { label: '10:00 PM UTC (Night peak)', value: '22:00' },
];

export default function Dashboard() {
  const [activeTab, setActiveTab] = useState('overview');
  const [config, setConfig] = useState({
    videosPerDay: 5,
    uploadEnabled: true,
    contentTypes: ['storytelling', 'dance', 'top5'],
    preferredTime: '19:00',
    voiceId: 'Rachel',
  });
  const [jobs, setJobs] = useState([]);
  const [stats, setStats] = useState({});
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');
  const [generating, setGenerating] = useState(false);

  const fetchData = useCallback(async () => {
    try {
      const [configRes, jobsRes, statsRes] = await Promise.all([
        fetch('/api/config'),
        fetch('/api/jobs'),
        fetch('/api/stats'),
      ]);
      if (configRes.ok) setConfig(prev => ({ ...prev, ...(await configRes.json()) }));
      if (jobsRes.ok) {
        const data = await jobsRes.json();
        setJobs(data.jobs || []);
      }
      if (statsRes.ok) setStats(await statsRes.json());
    } catch (err) {
      console.error('Fetch error:', err);
    }
  }, []);

  useEffect(() => {
    fetchData();
    const interval = setInterval(fetchData, 15000);
    return () => clearInterval(interval);
  }, [fetchData]);

  async function saveConfig() {
    setLoading(true);
    try {
      const res = await fetch('/api/config', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(config),
      });
      if (res.ok) showMessage('✅ Settings saved!', 'success');
      else showMessage('❌ Failed to save', 'error');
    } catch (err) {
      showMessage('❌ Error: ' + err.message, 'error');
    }
    setLoading(false);
  }

  async function triggerGeneration() {
    setGenerating(true);
    showMessage('🎬 Starting video generation...', 'info');
    try {
      const res = await fetch('/api/trigger', { method: 'POST' });
      const data = await res.json();
      if (res.ok) {
        showMessage(`✅ Video created! ${data.youtubeUrl ? '→ ' + data.youtubeUrl : ''}`, 'success');
        fetchData();
      } else {
        showMessage('❌ ' + (data.error || 'Generation failed'), 'error');
      }
    } catch (err) {
      showMessage('❌ Error: ' + err.message, 'error');
    }
    setGenerating(false);
  }

  function showMessage(msg, type) {
    setMessage({ text: msg, type });
    setTimeout(() => setMessage(''), 5000);
  }

  const toggleContentType = (type) => {
    setConfig(prev => ({
      ...prev,
      contentTypes: prev.contentTypes.includes(type)
        ? prev.contentTypes.filter(t => t !== type)
        : [...prev.contentTypes, type],
    }));
  };

  const nextUpload = () => {
    const [h, m] = (config.preferredTime || '19:00').split(':').map(Number);
    const now = new Date();
    const next = new Date();
    next.setUTCHours(h, m, 0, 0);
    if (next <= now) next.setUTCDate(next.getUTCDate() + 1);
    const diff = next - now;
    const hours = Math.floor(diff / 3600000);
    const mins = Math.floor((diff % 3600000) / 60000);
    return `${hours}h ${mins}m`;
  };

  return (
    <div style={styles.container}>
      <header style={styles.header}>
        <div style={styles.headerContent}>
          <div style={styles.logo}>
            <span style={styles.logoIcon}>🧠</span>
            <div>
              <h1 style={styles.headerTitle}>Brainrot Automation</h1>
              <p style={styles.headerSub}>Automated YouTube Content Generator</p>
            </div>
          </div>
          <div style={styles.headerStats}>
            <StatBadge label="Today" value={`${stats.todayVideos || 0} videos`} />
            <StatBadge label="Success" value={`${stats.successRate || 0}%`} />
            <StatBadge label="Next Upload" value={nextUpload()} color="#10b981" />
          </div>
        </div>
      </header>

      {message && (
        <div style={{
          ...styles.message,
          background: message.type === 'success' ? '#065f46' : message.type === 'error' ? '#7f1d1d' : '#1e3a5f',
        }}>
          {message.text}
        </div>
      )}

      <nav style={styles.nav}>
        {['overview', 'settings', 'jobs', 'api-keys'].map(tab => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            style={{ ...styles.navBtn, ...(activeTab === tab ? styles.navBtnActive : {}) }}
          >
            {tab === 'overview' ? '📊 Overview' :
              tab === 'settings' ? '⚙️ Settings' :
              tab === 'jobs' ? '📋 Jobs' : '🔑 API Keys'}
          </button>
        ))}
      </nav>

      <main style={styles.main}>
        {activeTab === 'overview' && (
          <div>
            <div style={styles.grid3}>
              <StatCard label="Total Videos" value={stats.totalVideos || 0} icon="🎬" />
              <StatCard label="Today's Videos" value={`${stats.todayVideos || 0} / ${config.videosPerDay}`} icon="📅" />
              <StatCard label="Success Rate" value={`${stats.successRate || 0}%`} icon="✅" />
            </div>

            <div style={styles.card}>
              <h2 style={styles.cardTitle}>🚀 Manual Generation</h2>
              <p style={{ color: '#9ca3af', marginBottom: '20px' }}>
                Trigger a video generation right now. The automation also runs on its own schedule.
              </p>
              <div style={styles.buttonRow}>
                <button
                  onClick={triggerGeneration}
                  disabled={generating}
                  style={{ ...styles.btnPrimary, opacity: generating ? 0.7 : 1 }}
                >
                  {generating ? '⏳ Generating...' : '🎬 Generate Video Now'}
                </button>
              </div>
              {stats.lastVideoUrl && (
                <div style={{ marginTop: '16px', padding: '12px', background: '#1f2937', borderRadius: '8px' }}>
                  <p style={{ color: '#9ca3af', fontSize: '14px', margin: '0 0 4px' }}>Last upload:</p>
                  <a href={stats.lastVideoUrl} target="_blank" rel="noreferrer" style={{ color: '#60a5fa' }}>
                    {stats.lastVideoUrl}
                  </a>
                </div>
              )}
            </div>

            <div style={styles.card}>
              <h2 style={styles.cardTitle}>📅 Upload Schedule (Vercel Cron)</h2>
              <p style={{ color: '#9ca3af', marginBottom: '16px' }}>
                These times are configured in <code style={{ color: '#f59e0b' }}>vercel.json</code> and run automatically:
              </p>
              <div style={styles.scheduleGrid}>
                {['9:00 AM UTC', '11:00 AM UTC', '2:00 PM UTC', '7:00 PM UTC ⭐', '10:00 PM UTC'].map((time, i) => (
                  <div key={i} style={styles.scheduleItem}>
                    <span style={{ color: '#10b981', fontWeight: 'bold' }}>📤</span>
                    <span style={{ color: '#e5e7eb' }}>{time}</span>
                  </div>
                ))}
              </div>
              <p style={{ color: '#6b7280', fontSize: '13px', marginTop: '12px' }}>
                ⭐ 7 PM UTC = 2 PM EST — peak YouTube engagement time based on research
              </p>
            </div>
          </div>
        )}

        {activeTab === 'settings' && (
          <div style={styles.card}>
            <h2 style={styles.cardTitle}>⚙️ Automation Settings</h2>

            <div style={styles.formGroup}>
              <label style={styles.label}>Videos Per Day: <strong style={{ color: '#f59e0b' }}>{config.videosPerDay}</strong></label>
              <input
                type="range"
                min="1"
                max="10"
                value={config.videosPerDay}
                onChange={e => setConfig(prev => ({ ...prev, videosPerDay: parseInt(e.target.value) }))}
                style={styles.range}
              />
              <div style={styles.rangeLabels}><span>1</span><span>5</span><span>10</span></div>
            </div>

            <div style={styles.formGroup}>
              <label style={styles.label}>Preferred Upload Time (UTC)</label>
              <select
                value={config.preferredTime}
                onChange={e => setConfig(prev => ({ ...prev, preferredTime: e.target.value }))}
                style={styles.select}
              >
                {OPTIMAL_TIMES.map(t => (
                  <option key={t.value} value={t.value}>{t.label}</option>
                ))}
              </select>
              <p style={styles.hint}>Vercel cron runs 5 times/day — adjust vercel.json for exact control</p>
            </div>

            <div style={styles.formGroup}>
              <label style={styles.label}>Content Types</label>
              <div style={styles.checkboxGroup}>
                {['storytelling', 'dance', 'top5'].map(type => (
                  <label key={type} style={styles.checkboxLabel}>
                    <input
                      type="checkbox"
                      checked={config.contentTypes?.includes(type)}
                      onChange={() => toggleContentType(type)}
                      style={{ marginRight: '8px' }}
                    />
                    {type === 'storytelling' ? '📖 Storytelling' : type === 'dance' ? '💃 Dance' : '🏆 Top 5'}
                  </label>
                ))}
              </div>
            </div>

            <div style={styles.formGroup}>
              <label style={styles.label}>Voice</label>
              <select
                value={config.voiceId}
                onChange={e => setConfig(prev => ({ ...prev, voiceId: e.target.value }))}
                style={styles.select}
              >
                <option value="Rachel">Rachel (Female, Warm)</option>
                <option value="Domi">Domi (Female, Energetic)</option>
                <option value="Bella">Bella (Female, Soft)</option>
                <option value="Antoni">Antoni (Male, Deep)</option>
                <option value="Elli">Elli (Female, Young)</option>
              </select>
            </div>

            <div style={styles.formGroup}>
              <label style={styles.checkboxLabel}>
                <input
                  type="checkbox"
                  checked={config.uploadEnabled}
                  onChange={e => setConfig(prev => ({ ...prev, uploadEnabled: e.target.checked }))}
                  style={{ marginRight: '8px' }}
                />
                Auto-upload to YouTube (uncheck to generate only, no upload)
              </label>
            </div>

            <button onClick={saveConfig} disabled={loading} style={styles.btnPrimary}>
              {loading ? '⏳ Saving...' : '💾 Save Settings'}
            </button>
          </div>
        )}

        {activeTab === 'jobs' && (
          <div style={styles.card}>
            <h2 style={styles.cardTitle}>📋 Generation Jobs</h2>
            {jobs.length === 0 ? (
              <p style={{ color: '#6b7280', textAlign: 'center', padding: '40px' }}>
                No jobs yet. Generate your first video!
              </p>
            ) : (
              <div style={styles.jobsList}>
                {jobs.map(job => (
                  <div key={job.id} style={styles.jobItem}>
                    <div style={styles.jobHeader}>
                      <StatusBadge status={job.status} />
                      <span style={{ color: '#9ca3af', fontSize: '13px' }}>
                        {new Date(job.createdAt).toLocaleString()}
                      </span>
                    </div>
                    <p style={{ color: '#e5e7eb', margin: '8px 0 4px', fontWeight: '500' }}>
                      {job.title || `${job.type} - ${job.character}`}
                    </p>
                    <p style={{ color: '#6b7280', fontSize: '13px', margin: '0' }}>
                      Type: {job.type} | Character: {job.character}
                    </p>
                    {job.youtubeUrl && (
                      <a href={job.youtubeUrl} target="_blank" rel="noreferrer" style={{ color: '#60a5fa', fontSize: '13px', display: 'block', marginTop: '6px' }}>
                        ▶ Watch on YouTube
                      </a>
                    )}
                    {job.error && (
                      <p style={{ color: '#f87171', fontSize: '13px', marginTop: '6px' }}>
                        Error: {job.error}
                      </p>
                    )}
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {activeTab === 'api-keys' && (
          <div>
            <div style={styles.card}>
              <h2 style={styles.cardTitle}>🔑 Required API Keys (All Free)</h2>
              <p style={{ color: '#9ca3af', marginBottom: '20px' }}>
                Set these in your Vercel dashboard under Settings → Environment Variables
              </p>
              {[
                {
                  name: 'MONGODB_URI',
                  label: 'MongoDB Atlas',
                  desc: 'Free M0 cluster (512MB)',
                  url: 'https://mongodb.com/cloud/atlas',
                  color: '#10b981',
                },
                {
                  name: 'YOUTUBE_CLIENT_ID + YOUTUBE_CLIENT_SECRET + YOUTUBE_REFRESH_TOKEN',
                  label: 'YouTube Data API v3',
                  desc: 'Free — 10,000 units/day',
                  url: 'https://console.cloud.google.com',
                  color: '#ef4444',
                },
                {
                  name: 'HUGGINGFACE_API_KEY',
                  label: 'HuggingFace (Image Gen)',
                  desc: 'Free — unlimited (rate limited)',
                  url: 'https://huggingface.co/settings/tokens',
                  color: '#f59e0b',
                },
                {
                  name: 'ELEVENLABS_API_KEY',
                  label: 'ElevenLabs TTS',
                  desc: 'Free — 10k chars/month',
                  url: 'https://elevenlabs.io',
                  color: '#8b5cf6',
                },
                {
                  name: 'OPENROUTER_API_KEY',
                  label: 'OpenRouter (Script Gen)',
                  desc: 'Free tier — Mistral-7B free',
                  url: 'https://openrouter.ai',
                  color: '#06b6d4',
                },
                {
                  name: 'CRON_SECRET',
                  label: 'Cron Secret',
                  desc: 'Generate: openssl rand -hex 32',
                  url: null,
                  color: '#6b7280',
                },
              ].map(key => (
                <div key={key.name} style={styles.apiKeyItem}>
                  <div style={{ ...styles.apiKeyDot, background: key.color }} />
                  <div style={{ flex: 1 }}>
                    <p style={{ color: '#e5e7eb', fontWeight: '600', margin: '0 0 2px' }}>{key.label}</p>
                    <code style={{ color: '#f59e0b', fontSize: '12px' }}>{key.name}</code>
                    <p style={{ color: '#6b7280', fontSize: '13px', margin: '2px 0 0' }}>{key.desc}</p>
                  </div>
                  {key.url && (
                    <a href={key.url} target="_blank" rel="noreferrer" style={styles.btnSmall}>
                      Get Key →
                    </a>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}
      </main>
    </div>
  );
}

function StatCard({ label, value, icon }) {
  return (
    <div style={styles.statCard}>
      <span style={{ fontSize: '32px' }}>{icon}</span>
      <div>
        <p style={{ color: '#9ca3af', fontSize: '14px', margin: '0' }}>{label}</p>
        <p style={{ color: '#e5e7eb', fontSize: '28px', fontWeight: 'bold', margin: '4px 0 0' }}>{value}</p>
      </div>
    </div>
  );
}

function StatBadge({ label, value, color }) {
  return (
    <div style={{ textAlign: 'center' }}>
      <p style={{ color: '#6b7280', fontSize: '11px', margin: '0' }}>{label}</p>
      <p style={{ color: color || '#e5e7eb', fontSize: '14px', fontWeight: 'bold', margin: '0' }}>{value}</p>
    </div>
  );
}

function StatusBadge({ status }) {
  const colors = {
    completed: { bg: '#065f46', color: '#34d399' },
    processing: { bg: '#1e3a5f', color: '#60a5fa' },
    pending: { bg: '#374151', color: '#9ca3af' },
    failed: { bg: '#7f1d1d', color: '#f87171' },
  };
  const c = colors[status] || colors.pending;
  return (
    <span style={{ background: c.bg, color: c.color, padding: '2px 10px', borderRadius: '20px', fontSize: '12px', fontWeight: '600' }}>
      {status}
    </span>
  );
}

const styles = {
  container: { minHeight: '100vh', background: '#0f1117', fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif' },
  header: { background: '#1a1d27', borderBottom: '1px solid #2d2f3e', padding: '16px 24px' },
  headerContent: { maxWidth: '1100px', margin: '0 auto', display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '12px' },
  logo: { display: 'flex', alignItems: 'center', gap: '12px' },
  logoIcon: { fontSize: '36px' },
  headerTitle: { color: '#e5e7eb', margin: '0', fontSize: '22px', fontWeight: '800' },
  headerSub: { color: '#6b7280', margin: '2px 0 0', fontSize: '13px' },
  headerStats: { display: 'flex', gap: '24px', alignItems: 'center' },
  message: { maxWidth: '1100px', margin: '16px auto 0', padding: '12px 20px', borderRadius: '8px', color: '#e5e7eb', fontWeight: '500' },
  nav: { maxWidth: '1100px', margin: '24px auto 0', padding: '0 24px', display: 'flex', gap: '4px', borderBottom: '1px solid #2d2f3e' },
  navBtn: { background: 'none', border: 'none', color: '#6b7280', padding: '10px 18px', cursor: 'pointer', fontSize: '14px', fontWeight: '500', borderBottom: '2px solid transparent', transition: 'all 0.2s' },
  navBtnActive: { color: '#60a5fa', borderBottomColor: '#3b82f6' },
  main: { maxWidth: '1100px', margin: '24px auto', padding: '0 24px 40px' },
  grid3: { display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '16px', marginBottom: '20px' },
  card: { background: '#1a1d27', border: '1px solid #2d2f3e', borderRadius: '12px', padding: '24px', marginBottom: '20px' },
  cardTitle: { color: '#e5e7eb', fontSize: '18px', fontWeight: '700', margin: '0 0 16px' },
  statCard: { background: '#1a1d27', border: '1px solid #2d2f3e', borderRadius: '12px', padding: '20px', display: 'flex', alignItems: 'center', gap: '16px' },
  formGroup: { marginBottom: '20px' },
  label: { display: 'block', color: '#d1d5db', fontSize: '14px', fontWeight: '600', marginBottom: '8px' },
  range: { width: '100%', accentColor: '#3b82f6' },
  rangeLabels: { display: 'flex', justifyContent: 'space-between', color: '#6b7280', fontSize: '12px', marginTop: '4px' },
  select: { width: '100%', background: '#0f1117', border: '1px solid #374151', color: '#e5e7eb', padding: '10px 12px', borderRadius: '8px', fontSize: '14px' },
  hint: { color: '#6b7280', fontSize: '12px', marginTop: '6px' },
  checkboxGroup: { display: 'flex', gap: '20px', flexWrap: 'wrap' },
  checkboxLabel: { color: '#d1d5db', fontSize: '14px', cursor: 'pointer', display: 'flex', alignItems: 'center' },
  btnPrimary: { background: 'linear-gradient(135deg, #3b82f6, #8b5cf6)', color: '#fff', border: 'none', padding: '12px 28px', borderRadius: '8px', fontSize: '15px', fontWeight: '700', cursor: 'pointer' },
  btnSmall: { background: '#1f2937', color: '#60a5fa', border: '1px solid #374151', padding: '6px 14px', borderRadius: '6px', fontSize: '13px', textDecoration: 'none', whiteSpace: 'nowrap' },
  buttonRow: { display: 'flex', gap: '12px', flexWrap: 'wrap' },
  jobsList: { display: 'flex', flexDirection: 'column', gap: '12px' },
  jobItem: { background: '#0f1117', border: '1px solid #2d2f3e', borderRadius: '8px', padding: '16px' },
  jobHeader: { display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '8px' },
  scheduleGrid: { display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '10px' },
  scheduleItem: { background: '#0f1117', border: '1px solid #2d2f3e', borderRadius: '8px', padding: '12px 16px', display: 'flex', alignItems: 'center', gap: '10px' },
  apiKeyItem: { display: 'flex', alignItems: 'flex-start', gap: '14px', padding: '14px 0', borderBottom: '1px solid #1f2937' },
  apiKeyDot: { width: '10px', height: '10px', borderRadius: '50%', marginTop: '6px', flexShrink: 0 },
};
DASHBOARD_EOF

# =============================================================================
# pages/index.js
# =============================================================================
cat > pages/index.js << 'INDEX_EOF'
import Head from 'next/head';
import dynamic from 'next/dynamic';

const Dashboard = dynamic(() => import('../components/Dashboard'), { ssr: false });

export default function Home() {
  return (
    <>
      <Head>
        <title>Brainrot Automation Dashboard</title>
        <meta name="description" content="Automated YouTube brainrot content generator" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg'><text y='32' font-size='32'>🧠</text></svg>" />
      </Head>
      <Dashboard />
    </>
  );
}
INDEX_EOF

# =============================================================================
# pages/_app.js
# =============================================================================
cat > pages/_app.js << 'APP_EOF'
import '../styles/globals.css';

export default function App({ Component, pageProps }) {
  return <Component {...pageProps} />;
}
APP_EOF

# =============================================================================
# styles/globals.css
# =============================================================================
mkdir -p styles
cat > styles/globals.css << 'CSS_EOF'
*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html, body {
  background: #0f1117;
  color: #e5e7eb;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

input[type="range"] {
  appearance: none;
  height: 6px;
  background: #374151;
  border-radius: 3px;
  outline: none;
}

input[type="range"]::-webkit-slider-thumb {
  appearance: none;
  width: 18px;
  height: 18px;
  background: #3b82f6;
  border-radius: 50%;
  cursor: pointer;
}

::-webkit-scrollbar { width: 6px; }
::-webkit-scrollbar-track { background: #0f1117; }
::-webkit-scrollbar-thumb { background: #374151; border-radius: 3px; }

code { font-family: 'Courier New', monospace; }
CSS_EOF

# =============================================================================
# data/characters.json
# =============================================================================
cat > data/characters.json << 'CHARS_EOF'
{
  "characters": [
    {
      "name": "Skibidi Toilet",
      "style": "toilet head character, waving, bathroom chaos, cartoon",
      "tags": ["skibidi", "toilet", "brainrot"]
    },
    {
      "name": "Sigma Cat",
      "style": "cool cat with sunglasses, sigma face, anime style, confident",
      "tags": ["sigma", "cat", "anime"]
    },
    {
      "name": "Baby Gronk",
      "style": "young football player, rizz pose, stadium background, energetic",
      "tags": ["babygronk", "football", "rizz"]
    },
    {
      "name": "Based Gigachad",
      "style": "ultra chad face, muscular, extremely confident pose, dramatic lighting",
      "tags": ["gigachad", "sigma", "based"]
    },
    {
      "name": "NPC Girl",
      "style": "anime NPC character, pink hair, repetitive gesture pose, pixel style",
      "tags": ["npc", "anime", "brainrot"]
    },
    {
      "name": "Rizz God",
      "style": "charismatic character, glowing aura, smooth confident pose, stylish",
      "tags": ["rizz", "sigma", "goat"]
    },
    {
      "name": "Ohio Man",
      "style": "average looking guy in ohio, shocked expression, surreal background",
      "tags": ["ohio", "weird", "surreal"]
    },
    {
      "name": "Gyatt Master",
      "style": "confident character, surprised crowd around them, meme style",
      "tags": ["gyatt", "sigma", "viral"]
    }
  ]
}
CHARS_EOF

# =============================================================================
# README.md
# =============================================================================
cat > README.md << 'README_EOF'
# 🧠 Brainrot Content Automation

Automated YouTube Shorts generator using free AI services. Deploys to Vercel with zero monthly cost.

## 🚀 Quick Start

### 1. Get Free API Keys (5 min)
- **MongoDB**: [mongodb.com/cloud/atlas](https://mongodb.com/cloud/atlas) → Create free M0 cluster
- **YouTube API**: [console.cloud.google.com](https://console.cloud.google.com) → Enable YouTube Data API v3
- **HuggingFace**: [huggingface.co/settings/tokens](https://huggingface.co/settings/tokens) → Create token
- **ElevenLabs**: [elevenlabs.io](https://elevenlabs.io) → Create account
- **OpenRouter**: [openrouter.ai](https://openrouter.ai) → Free Mistral-7B access
- **Cron Secret**: Run `openssl rand -hex 32`

### 2. Deploy to Vercel (5 min)
```bash
npm install -g vercel
vercel
```
Then add all env vars in Vercel Dashboard → Settings → Environment Variables.

### 3. Get YouTube Refresh Token
1. Go to [Google OAuth Playground](https://developers.google.com/oauthplayground)
2. Select YouTube Data API v3 scopes
3. Exchange for refresh token
4. Add to YOUTUBE_REFRESH_TOKEN env var

## 🕐 Optimal Upload Times
Configured in `vercel.json` to run at:
- 9:00 AM UTC (Asian audience)
- 11:00 AM UTC (Morning peak)
- 2:00 PM UTC (Afternoon peak)
- **7:00 PM UTC ⭐ (Best time = 2 PM EST)**
- 10:00 PM UTC (Night audience)

## 💰 Cost Breakdown
| Service | Cost |
|---------|------|
| Vercel | $0 |
| MongoDB M0 | $0 |
| HuggingFace | $0 |
| OpenRouter (Mistral) | $0 |
| ElevenLabs | $0 (10k chars/mo) |
| YouTube API | $0 |
| **Total** | **$0/month** |

## 🤖 Free AI Services Used
- **HuggingFace** - Stable Diffusion (image generation)
- **OpenRouter** - Mistral-7B (script writing)
- **ElevenLabs** - TTS voices
- **StreamElements** - Fallback TTS (no key needed!)
- **FFmpeg** - Video creation

## 📁 Project Structure
```
brainrot-automation/
├── pages/
│   ├── index.js              # Dashboard page
│   ├── _app.js               # Next.js app wrapper
│   └── api/
│       ├── config.js         # Settings API
│       ├── jobs.js           # Jobs tracking API
│       ├── stats.js          # Statistics API
│       ├── trigger.js        # Manual trigger
│       └── cron/
│           └── generate-videos.js  # Main automation
├── components/
│   └── Dashboard.jsx         # UI dashboard
├── lib/
│   ├── mongodb.js            # DB connection
│   ├── models.js             # Mongoose schemas
│   ├── aiServices.js         # AI API wrappers
│   ├── youtubeUploader.js    # YouTube upload
│   └── videoCreator.js       # FFmpeg video creation
├── data/
│   └── characters.json       # Brainrot characters
├── styles/
│   └── globals.css           # Global styles
├── vercel.json               # Cron schedule config
├── next.config.js            # Next.js config
└── package.json
```
README_EOF

echo -e "${GREEN}✓ README.md created${NC}"

# =============================================================================
# INSTALL DEPENDENCIES
# =============================================================================
echo -e "${BLUE}[7/8] Installing npm dependencies...${NC}"
npm install --silent 2>/dev/null || echo -e "${YELLOW}⚠ npm install will run when you open the project${NC}"

# =============================================================================
# FINAL SUMMARY
# =============================================================================
echo -e "${BLUE}[8/8] Setup complete!${NC}"
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                  ✅ SETUP COMPLETE!                         ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}📁 Project created at: ${YELLOW}$(pwd)${NC}"
echo ""
echo -e "${CYAN}📋 Files created:${NC}"
ls -la --color=never 2>/dev/null || ls -la
echo ""
echo -e "${CYAN}🚀 Next Steps:${NC}"
echo ""
echo -e "  ${YELLOW}1. Edit .env.local with your API keys:${NC}"
echo -e "     ${GREEN}nano .env.local${NC}"
echo ""
echo -e "  ${YELLOW}2. Test locally:${NC}"
echo -e "     ${GREEN}npm run dev${NC}"
echo -e "     Open: http://localhost:3000"
echo ""
echo -e "  ${YELLOW}3. Deploy to Vercel:${NC}"
echo -e "     ${GREEN}npx vercel${NC}"
echo ""
echo -e "  ${YELLOW}4. Add env vars in Vercel Dashboard:${NC}"
echo -e "     Go to: Settings → Environment Variables"
echo -e "     Add all keys from .env.local"
echo ""
echo -e "${CYAN}🔑 Free API Keys You Need:${NC}"
echo -e "  ${GREEN}1.${NC} MongoDB Atlas → https://mongodb.com/cloud/atlas"
echo -e "  ${GREEN}2.${NC} YouTube API → https://console.cloud.google.com"
echo -e "  ${GREEN}3.${NC} HuggingFace → https://huggingface.co/settings/tokens"
echo -e "  ${GREEN}4.${NC} ElevenLabs → https://elevenlabs.io"
echo -e "  ${GREEN}5.${NC} OpenRouter → https://openrouter.ai (free Mistral)"
echo -e "  ${GREEN}6.${NC} Cron Secret → run: openssl rand -hex 32"
echo ""
echo -e "${CYAN}⏰ Auto-upload schedule (vercel.json):${NC}"
echo -e "  Runs 5x per day at: 9am, 11am, 2pm, 7pm★, 10pm UTC"
echo -e "  ★ 7pm UTC = 2pm EST = peak YouTube engagement"
echo ""
echo -e "${GREEN}💰 Total monthly cost: \$0 (all free APIs!)${NC}"
echo ""
echo -e "${CYAN}Good luck! 🧠🔥${NC}"