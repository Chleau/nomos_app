-- ============================================
-- Script de Vérification Supabase
-- À exécuter dans l'éditeur SQL de Supabase
-- ============================================

-- 1. Vérifier que la table photos_signalement existe
SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'photos_signalement'
ORDER BY ordinal_position;

-- 2. Vérifier que la table signalements existe
SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'signalements'
ORDER BY ordinal_position;

-- 3. Vérifier les clés étrangères
SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'photos_signalement';

-- 4. Test d'insertion manuelle (pour vérifier les permissions)
-- ATTENTION: Remplacez 1 par un ID de signalement existant
-- INSERT INTO photos_signalement (signalement_id, url)
-- VALUES (1, 'https://test.com/test.jpg');

-- 5. Vérifier les politiques RLS sur photos_signalement
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies
WHERE tablename = 'photos_signalement';

-- 6. Vérifier si RLS est activé
SELECT
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables
WHERE tablename IN ('photos_signalement', 'signalements');

