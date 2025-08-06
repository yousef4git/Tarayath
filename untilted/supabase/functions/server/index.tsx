import { Hono } from 'npm:hono';
import { cors } from 'npm:hono/cors';
import { logger } from 'npm:hono/logger';
import { createClient } from 'npm:@supabase/supabase-js@2';
import * as kv from './kv_store.tsx';

const app = new Hono();

// Middleware
app.use('*', cors({
  origin: '*',
  allowMethods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowHeaders: ['Content-Type', 'Authorization'],
}));
app.use('*', logger(console.log));

// Initialize Supabase client
const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
);

// User registration
app.post('/make-server-13fd9a1c/signup', async (c) => {
  try {
    const { email, password, fullName } = await c.req.json();
    
    if (!email || !password || !fullName) {
      return c.json({ error: 'Missing required fields' }, 400);
    }

    const { data, error } = await supabase.auth.admin.createUser({
      email,
      password,
      user_metadata: { name: fullName },
      // Automatically confirm the user's email since an email server hasn't been configured.
      email_confirm: true
    });

    if (error) {
      console.log('Signup error:', error);
      return c.json({ error: error.message }, 400);
    }

    return c.json({ user: data.user });
  } catch (error) {
    console.log('Signup exception:', error);
    return c.json({ error: 'Internal server error during signup' }, 500);
  }
});

// Save user financial data
app.post('/make-server-13fd9a1c/user-data', async (c) => {
  try {
    const accessToken = c.req.header('Authorization')?.split(' ')[1];
    if (!accessToken) {
      return c.json({ error: 'Missing authorization token' }, 401);
    }

    const { data: { user }, error: authError } = await supabase.auth.getUser(accessToken);
    if (authError || !user) {
      console.log('Auth error in user data save:', authError);
      return c.json({ error: 'Unauthorized' }, 401);
    }

    const userData = await c.req.json();
    await kv.set(`user_data:${user.id}`, userData);
    
    return c.json({ success: true });
  } catch (error) {
    console.log('Error saving user data:', error);
    return c.json({ error: 'Failed to save user data' }, 500);
  }
});

// Get user financial data
app.get('/make-server-13fd9a1c/user-data', async (c) => {
  try {
    const accessToken = c.req.header('Authorization')?.split(' ')[1];
    if (!accessToken) {
      return c.json({ error: 'Missing authorization token' }, 401);
    }

    const { data: { user }, error: authError } = await supabase.auth.getUser(accessToken);
    if (authError || !user) {
      console.log('Auth error in user data fetch:', authError);
      return c.json({ error: 'Unauthorized' }, 401);
    }

    const userData = await kv.get(`user_data:${user.id}`);
    
    return c.json({ userData });
  } catch (error) {
    console.log('Error fetching user data:', error);
    return c.json({ error: 'Failed to fetch user data' }, 500);
  }
});

// Save savings plan
app.post('/make-server-13fd9a1c/savings-plan', async (c) => {
  try {
    const accessToken = c.req.header('Authorization')?.split(' ')[1];
    if (!accessToken) {
      return c.json({ error: 'Missing authorization token' }, 401);
    }

    const { data: { user }, error: authError } = await supabase.auth.getUser(accessToken);
    if (authError || !user) {
      console.log('Auth error in savings plan save:', authError);
      return c.json({ error: 'Unauthorized' }, 401);
    }

    const savingsPlan = await c.req.json();
    savingsPlan.createdAt = new Date().toISOString();
    savingsPlan.userId = user.id;
    
    await kv.set(`savings_plan:${user.id}`, savingsPlan);
    
    return c.json({ success: true });
  } catch (error) {
    console.log('Error saving savings plan:', error);
    return c.json({ error: 'Failed to save savings plan' }, 500);
  }
});

// Get savings plan
app.get('/make-server-13fd9a1c/savings-plan', async (c) => {
  try {
    const accessToken = c.req.header('Authorization')?.split(' ')[1];
    if (!accessToken) {
      return c.json({ error: 'Missing authorization token' }, 401);
    }

    const { data: { user }, error: authError } = await supabase.auth.getUser(accessToken);
    if (authError || !user) {
      console.log('Auth error in savings plan fetch:', authError);
      return c.json({ error: 'Unauthorized' }, 401);
    }

    const savingsPlan = await kv.get(`savings_plan:${user.id}`);
    
    return c.json({ savingsPlan });
  } catch (error) {
    console.log('Error fetching savings plan:', error);
    return c.json({ error: 'Failed to fetch savings plan' }, 500);
  }
});

// Update savings progress
app.post('/make-server-13fd9a1c/savings-progress', async (c) => {
  try {
    const accessToken = c.req.header('Authorization')?.split(' ')[1];
    if (!accessToken) {
      return c.json({ error: 'Missing authorization token' }, 401);
    }

    const { data: { user }, error: authError } = await supabase.auth.getUser(accessToken);
    if (authError || !user) {
      console.log('Auth error in savings progress update:', authError);
      return c.json({ error: 'Unauthorized' }, 401);
    }

    const { currentSavings } = await c.req.json();
    
    // Get existing plan
    const existingPlan = await kv.get(`savings_plan:${user.id}`);
    if (!existingPlan) {
      return c.json({ error: 'No savings plan found' }, 404);
    }

    // Update current savings
    existingPlan.currentSavings = currentSavings;
    existingPlan.lastUpdated = new Date().toISOString();
    
    await kv.set(`savings_plan:${user.id}`, existingPlan);
    
    return c.json({ success: true });
  } catch (error) {
    console.log('Error updating savings progress:', error);
    return c.json({ error: 'Failed to update savings progress' }, 500);
  }
});

// Save expense analysis
app.post('/make-server-13fd9a1c/expense-analysis', async (c) => {
  try {
    const accessToken = c.req.header('Authorization')?.split(' ')[1];
    if (!accessToken) {
      return c.json({ error: 'Missing authorization token' }, 401);
    }

    const { data: { user }, error: authError } = await supabase.auth.getUser(accessToken);
    if (authError || !user) {
      console.log('Auth error in expense analysis save:', authError);
      return c.json({ error: 'Unauthorized' }, 401);
    }

    const expenseData = await c.req.json();
    expenseData.createdAt = new Date().toISOString();
    expenseData.userId = user.id;
    
    await kv.set(`expense_analysis:${user.id}`, expenseData);
    
    return c.json({ success: true });
  } catch (error) {
    console.log('Error saving expense analysis:', error);
    return c.json({ error: 'Failed to save expense analysis' }, 500);
  }
});

// Get expense analysis
app.get('/make-server-13fd9a1c/expense-analysis', async (c) => {
  try {
    const accessToken = c.req.header('Authorization')?.split(' ')[1];
    if (!accessToken) {
      return c.json({ error: 'Missing authorization token' }, 401);
    }

    const { data: { user }, error: authError } = await supabase.auth.getUser(accessToken);
    if (authError || !user) {
      console.log('Auth error in expense analysis fetch:', authError);
      return c.json({ error: 'Unauthorized' }, 401);
    }

    const expenseAnalysis = await kv.get(`expense_analysis:${user.id}`);
    
    return c.json({ expenseAnalysis });
  } catch (error) {
    console.log('Error fetching expense analysis:', error);
    return c.json({ error: 'Failed to fetch expense analysis' }, 500);
  }
});

// Save purchase decisions for tracking
app.post('/make-server-13fd9a1c/purchase-decision', async (c) => {
  try {
    const accessToken = c.req.header('Authorization')?.split(' ')[1];
    if (!accessToken) {
      return c.json({ error: 'Missing authorization token' }, 401);
    }

    const { data: { user }, error: authError } = await supabase.auth.getUser(accessToken);
    if (authError || !user) {
      console.log('Auth error in purchase decision save:', authError);
      return c.json({ error: 'Unauthorized' }, 401);
    }

    const purchaseData = await c.req.json();
    purchaseData.createdAt = new Date().toISOString();
    purchaseData.userId = user.id;
    
    // Save individual purchase decision
    const purchaseId = Date.now().toString();
    await kv.set(`purchase_decision:${user.id}:${purchaseId}`, purchaseData);
    
    return c.json({ success: true, purchaseId });
  } catch (error) {
    console.log('Error saving purchase decision:', error);
    return c.json({ error: 'Failed to save purchase decision' }, 500);
  }
});

// Get purchase history
app.get('/make-server-13fd9a1c/purchase-history', async (c) => {
  try {
    const accessToken = c.req.header('Authorization')?.split(' ')[1];
    if (!accessToken) {
      return c.json({ error: 'Missing authorization token' }, 401);
    }

    const { data: { user }, error: authError } = await supabase.auth.getUser(accessToken);
    if (authError || !user) {
      console.log('Auth error in purchase history fetch:', authError);
      return c.json({ error: 'Unauthorized' }, 401);
    }

    const purchases = await kv.getByPrefix(`purchase_decision:${user.id}:`);
    
    return c.json({ purchases: purchases || [] });
  } catch (error) {
    console.log('Error fetching purchase history:', error);
    return c.json({ error: 'Failed to fetch purchase history' }, 500);
  }
});

Deno.serve(app.fetch);