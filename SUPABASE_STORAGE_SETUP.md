# Configuration Supabase pour les Photos de Signalement

## Bucket de Stockage

Pour que l'upload des photos fonctionne, vous devez créer un bucket de stockage dans Supabase :

1. Allez dans votre projet Supabase
2. Naviguez vers **Storage** dans le menu latéral
3. Cliquez sur **New Bucket**
4. Créez un bucket avec les paramètres suivants :
   - **Nom** : `photos`
   - **Public** : Coché (pour permettre l'accès public aux URLs)
   - **File size limit** : 5MB (ou selon vos besoins)
   - **Allowed MIME types** : `image/*`

## Politique de Sécurité (RLS)

Vous pouvez ajouter des politiques RLS pour sécuriser le bucket :

### Politique de Upload (INSERT)
```sql
-- Permet aux utilisateurs authentifiés d'uploader des photos
CREATE POLICY "Allow authenticated users to upload photos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'photos');
```

### Politique de Lecture (SELECT)
```sql
-- Permet à tout le monde de voir les photos publiques
CREATE POLICY "Allow public read access"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'photos');
```

### Politique de Suppression (DELETE)
```sql
-- Permet aux utilisateurs de supprimer leurs propres photos
CREATE POLICY "Allow users to delete their own photos"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'photos' AND auth.uid() = owner);
```

## Structure des fichiers

Les photos sont stockées avec le chemin suivant :
```
signalements/{signalement_id}_{timestamp}.jpg
```

Exemple : `signalements/42_1700425689123.jpg`

