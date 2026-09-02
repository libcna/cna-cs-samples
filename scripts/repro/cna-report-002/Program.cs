// CNA-REPORT-002: destroying the owned view returned by cna_effect_get_current_technique (or by
// cna_effect_technique_get_passes) invalidates the effect's real technique, so the second frame
// of any Model draw fails.
//
// The C ABI documents both as owned views -- effects.h:1419 "Gets the current technique as an
// owned stable view", effects.h:1087 "Receives an owned pass-collection view handle" -- which is
// why CNA.NET's ModelMesh.Draw destroys them each frame rather than leaving hundreds of native
// handles a second to the finalizers.
//
// Draws the same mesh on several consecutive frames and reports the first that fails.
using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace EffectTechniqueLifetime
{
    public class ReproGame : Game
    {
        private readonly int _frames;
        private GraphicsDeviceManager _graphics;
        private Model _model;
        private int _frame;
        private int _ok;

        public ReproGame(int frames)
        {
            _frames = frames;
            _graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";
        }

        protected override void LoadContent() => _model = Content.Load<Model>("Car");

        protected override void Draw(GameTime gameTime)
        {
            _frame++;
            try
            {
                foreach (ModelMesh mesh in _model.Meshes)
                {
                    foreach (Effect e in mesh.Effects)
                    {
                        if (e is BasicEffect be)
                        {
                            be.World = Matrix.Identity;
                            be.View = Matrix.CreateLookAt(new Vector3(0, 0, 500), Vector3.Zero, Vector3.Up);
                            be.Projection = Matrix.CreatePerspectiveFieldOfView(0.9f, 1.6f, 1f, 10000f);
                        }
                        else
                        {
                            e.Parameters["WorldViewProjection"].SetValue(Matrix.Identity);
                            e.Parameters["World"].SetValue(Matrix.Identity);
                            e.Parameters["TargetColor"].SetValue(Vector3.One);
                        }
                    }
                    mesh.Draw();
                }
                _ok++;
                Console.WriteLine($"frame {_frame}: mesh.Draw() OK");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"frame {_frame}: mesh.Draw() THREW {ex.GetType().Name}: {ex.Message}");
                Console.WriteLine($"RESULT: {_ok} frame(s) succeeded before the failure. " +
                                  "The defect is present when that number is 1.");
                Exit();
                return;
            }

            if (_frame >= _frames)
            {
                Console.WriteLine($"RESULT: all {_frames} frames succeeded -- the defect is gone.");
                Exit();
            }

            base.Draw(gameTime);
        }

        private static void Main(string[] args)
        {
            int frames = args.Length > 0 && int.TryParse(args[0], out int f) ? f : 6;
            using (var g = new ReproGame(frames)) g.Run();
        }
    }
}
